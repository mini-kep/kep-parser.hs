# В чем проблемы

Есть базовая статья про монадические парсеры ([Huttom][HM] + [код к ней](Hutton.hs)), в которой в нотации используются массивы `String -> [(a, String)]`.

Разобрать код с ходу не удалось . Полез копаться - есть пара пересказов статьи в блогах и пара "улучшений" - переход на более современную нотацию и более точные абстрацкции. Но поскольку базовый алгоритм не усвоен, "расшифровки" особо не помогли.

Есть более или менее компактный код парсера - [Haste](Haste.hs), который нравится читать,
но к нему нет примеров. На примере этого когда хотелось бы разобраться с тем:
- как объединять парсеры
- как в результате работы с одним символом, получается строка
- несколько мест в синтаксисе
- возможно, замахнуться на связь с StateT.

Я прокомментировал [Haste](Haste.hs) со своими вопросами, остальные мысли ниже.


## 1. Мало примеров использования и минимиальных

Я понимаю задачу парсинга как преобразовать "(1+2)" в 3. Классический разбор - 
сначала в токены, а с "комбинированием парсеров" можно без токенов сразу какое-то 
значение вычислять (?). 

## 2. Непонятно, где перескок на с "парсить один символ" на "отпарсить всю строку"

В туториалах примеры обычно в конце где-то и связь как парсеры одного символа 
стали вдруг парсить все вместе строку как-то теряется.

## 3. Тип "дерево" меняется на тип "a"

В презентациях еще часто пишут, что задач парсера это построить какое-то дерево 
`P String -> Maybe (Tree, String)` (например, пятый слайд [тут][verb]), но что такое дерево - не очень понятно, как оно буджет вервиться, как определяется структура и тд. Потом в объяснениях вдруг забивают, и говорят, а давайте смотреть на тип `P String -> Maybe (а, String)`. Куда делось дерево я не понимаю, но может оно и не нужно.

[verb]: https://research.jetbrains.org/files/material/564c9ffdaddf2.pdf

В "классических" примерах парсер работает в массив туплов `String -> [(a, String)]`,
причем массив используется факутически как контейнер Maybe или Either, но иногда
говорят, что массив этот - плоский вариант дерева, в котором собраны варинаты для случая неоднозначного парсера. Приходит на ум пример с регулярными выражениями, результат мэтчинга часто - это список вхождений.

## 4. Исходная статья про парсерв написана с типом `String -> [(a, String)]`

По-моему, если не нужно хранить список результатов (парсер однозначный), гораздо интереснее 
и понятнее что-то далать с типом `P String -> Maybe (а, String)`, это нас переключает
на с распаковки массива на проверку Just/Nothing, как-то содержательнее это.


## 5. "И вообще парсер это StateT"

Есть пример пересказа статьи Hutton со StateT [Diehl](Diehl.hs)


## 6. Статья на русском не помогла.

На русском есть статья про [Applicative parser](https://habr.com/ru/post/436234/) 
на Хабре, но она мне не помогла - какие-то вещи в ней очень просто, а какие-то - затык.


# Review goals

> [parsing is often the most annoying problem](https://www.dabeaz.com/ply/PLYTalk.pdf)


## Task inputs and expected outputs

Usually materials are given with few motivational examples of what is parsed to what, which appear at the end. Sometimes there are libraries without tests or examples (eg.Haste.hs).

## High-level overviews

- [Understanding parser combinators](https://fsharpforfunandprofit.com/posts/understanding-parser-combinators/), [slides](https://www.slideshare.net/ScottWlaschin/understanding-parser-combinators). Все здорово, но презенатция на F#.


## Academic paper

[Monadic Parsing in Haskell. Graham Hutton and Erik Meijer.][HM](*= HM paper*). Around 1990s.

[HM]: http://www.cs.nott.ac.uk/~pszgmh/pearl.pdf

>  In the spiritof one-stop  shopping, the paper combines material from three areas into a singlesource. The three areas are functional parsers (Burge, 1975; Wadler, 1985; Hutton,1992; Fokker, 1995), the use of monads to structure functional programs (Wadler,1990;  Wadler,  1992a;  Wadler,  1992b),  and  the  use  of  special  syntax  for  monadic programs  in  Haskell  (Jones,  1995;  Petersonet  al.,  1996).


## Write your own parser from scratch

1\. [Hutton](Hutton.hs) is code form the from the textbook, but follows [HM Paper][HM] closely:

   - [code from artice](https://gist.github.com/kseo/8049897)
   - [code from textbook](Hutton.hs)
   - [F++](https://gist.github.com/muratg/4163717) version of article code with a test.

2\.Following are reviews of [Hutton](Hutton.hs):

- Some teacher chapters:
  - [Diehl](Diehl.hs)
  - [Sagar](Sagar.hs)

- Some student blogs:
  - [Arun](Arun.hs)
  - [Bendersky](Eliben.hs)

3\. Interesting stand-alone articles
  - [Abrahamson](Abrahamson.hs) (applicative only, from a SO post)
  - [Anka.hs](Anka.hs) - very minimalistsic parser, but broken
  - [Haste](Haste.hs) working library, nice code style, but could not find tests, 
 

## Ideas and appraoches of parsing 

- Parser combinations
- Applicative vs monadic parsing
- Other strains 
  
## Production grade libraries

- parsec
- attoparsec
- other reviews

## Other themes

- the regex's

<!--

- [ ] принципы парсинга (поставновка задачи, примеры исходных и результата)
- [ ] обзор онлайн-публикаций и печатной литературы 
- [ ] примеры с полным кодом
- [ ] промышленные библиотеки
- [ ] сторонние примеры (regex)

https://github.com/mini-kep/kep-parser.hs/issues/2

-->