
&После("ПриНачалеРаботыСистемы")
Процедура БЗ_ПриНачалеРаботыСистемы(Знач ОповещениеЗавершения, НепрерывноеВыполнение)
	
	ПодключитьОбработчикОжидания("БЗ_ОбработатьОповещенияПользователя", 5, Ложь);
КонецПроцедуры


