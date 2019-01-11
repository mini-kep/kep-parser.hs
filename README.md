# kep-parser.hs

Rosstat time series parser in Haskell - transform a badly structured text dump to a machine-readable CSV file.

## Текущие комментарии и вопросы

См. [comment.md](comment.md)


## Задача

Из текствого файла с разнородными таблицами
получить данные в CSV файла с колонками `название переменной - 
частота - год - период - значение'. 

Пример: исходный файл `gdp.txt` конверируется в `gdp.csv`

`gdp.txt`

```
GDP, % change to year earlier
2017	100,6	102,5	102,2	100,9
2018	101,3	101,9	101,5	
```

`gdp.csv`

```
GDP_yoy	2017	q	1	100,6
GDP_yoy	2017	q	2	102,5
GDP_yoy	2017	q	3	102,2
GDP_yoy	2017	q	4	100,9
GDP_yoy	2018	q	1	101,3
GDP_yoy	2018	q	2	101,9
GDP_yoy	2018	q	3	101,5
GDP_yoy	2018	q	4	
```

Пример реального исходного файла: [tab.csv](https://raw.githubusercontent.com/mini-kep/parser-rosstat-kep/dev/data/interim/2018/07/tab.csv)

## Алгоритм

### На входе

- исходный текстовый файл типа `gdp.txt` или `tab.csv`
- словарь для парсинга названий переменных (например `Индекс промышленного производства` -> `INDPRO`)
- словарь для парсинга размерности переменных (например
  `в % к предыдущему периоду` -> `rog`)

### На выходе

- CSV файл с колонками `название переменной - частота - год - период - значение'

### Псевдокод

1. Прочитать текстовый файл как CSV
2. Разбить весь файл на таблицы. Таблица имеет заголовоки и блок данных
3. В каждой таблице:
   - определить идентификатор (label) переменной по заголовку таблицы. label состоит 
     из названия переменной (например, `INDPRO`) и (например, `rog`)  
   - по количеству столбцов в таблице определить, какие частоты данных содержатся в ней
   - выдать данные из таблицы в формате [`[название переменной - частота - год - период - значение]`]
4. Получить данные из всех таблиц
5. Записать эти данные в файл

## "Псевдосигнатура"

`FilePath -> ByteString -> [Row] -> [Table] -> [Map] -> [Map] -> [Variable] -> [DataTuple] -> ByteString -> FilePath`

- `FilePath` - пути к исходному и результирующему файлу
- `Table` - таблица с блоком заголовков и блоком данных
- `[Мap]` - словарь с соотвествием текста заголовка названию переменной или размерности переменной
- [Variable] - распарсенный `Table` 
- `[DataTuple]` - кортежи [`название переменной - частота - год - период - значение`]. Частота может быть годовой, квартальной или месячной. 


## Почему не все так просто

### Самая неприятная часть

На название переменной текущей таблицы иногда влияет предыдущая таблица. В примере 
ниже имя переменной `Индекс промышленного производства` не содержится во второй таблице,
там указано только размерность `в % к предыдущему периоду`.

```
1.2. Индекс промышленного производства1) / Industrial Production index1)				в % к соответствующему периоду предыдущего года / percent of corresponding period of previous year																	
2018		102,8	103,2			102,4	103,2	102,8	103,9	103,7	102,2	103,9					
в % к предыдущему периоду / percent of previous period								
2018		85,6	105,4			79,3	97,5	113,4	96,9	101,5	99,8	99,7					
```

### Неприятно, но не смертельно

- Количество столбцов не всегда опредеяет формат данных.
- Разнообразные конфликты в названиях переменных, которые ведут к тому что:
  - перебор названию по словарю нужно внутри таблицы идет
  - иногда нужно брать только фрагмент файла (две таблицы с одной переменной)
- Исходные файлы месячные за несколько лет, меняется названия переменных
- В значениях могут подмешать лишние символы, например `101,61)2)`
- Иногда Росстат преподносит всякие непредвиденные и неприятные сюрпризы в 
  формат данных