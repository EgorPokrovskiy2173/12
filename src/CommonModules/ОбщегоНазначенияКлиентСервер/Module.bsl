&Вместо("ЗначениеОжидаемогоТипа")
Функция БЗ_ЗначениеОжидаемогоТипа(Значение, ОжидаемыеТипы)
	Если ТипЗнч(Значение) = Тип("СправочникСсылка.БЗ_СтатьиБазыЗнанийПрисоединенныеФайлы") Тогда	
		Возврат Истина;		
	КонецЕсли;
	Результат = ПродолжитьВызов(Значение, ОжидаемыеТипы);
	Возврат Результат;
КонецФункции
