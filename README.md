## Назначение
Программа предназначена для поиска возможных мест расположения дефектов в виде трещин по результатам модальных испытаний. 

## Исходные данные
1. Временные сигналы датчиков аксселерометров, соответствующие одному из собственных тонов исследуемой конструкции. 
2. Последовательность координат, характеризующая ключевую геометрию анализируемой модели.

## Принцип работы
В основе алгоритма лежит гармонический анализ, целью которого является выделение из сигнала нелинейных искажений, характеризующих диссипацию энергии вблизи берегов трещин в ходе колебательного процесса. Результирующие нормированные нелинейные искажения интерполируются в пределах ключевой геометрии, заданной пользователем. 

## Примеры работы
* Нервюра крыла самолета *RRJ-95*:
![](RibRRJ.jpg)

* Нервюра крыла самолета *СУ-27*:
![](Rib.jpg)

* Авиационная панель с надрезом в центральной части и дефектами в виде трещин в стрингерах:
![](Panel.jpg)

## Апробация
Результаты работы программы вошли в [диссертацию](https://www.nstu.ru/files/dissertations/avtoreferat_zhukov_15484089174.pdf) Жукова Е. П.
