////////////////////////////////////////////////////////////////////////////////
// ПРОЧИЕ МЕТОДЫ

Функция ЗначениеДопСвойства(Имя, ПоУмолчанию)
	
	Если ЭтотОбъект.ДополнительныеСвойства.Свойство(Имя) Тогда
		Возврат ЭтотОбъект.ДополнительныеСвойства[Имя];
	Иначе 
		Возврат ПоУмолчанию;
	КонецЕсли;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ФОРМИРОВАНИЕ ДВИЖЕНИЙ СПРАВОЧНИКА

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТКА СОБЫТИЙ МОДУЛЯ

Процедура ПередЗаписью(Отказ)
	
	Если ЭтотОбъект.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ЭтотОбъект.ДополнительныеСвойства.Вставить("ЭтоНовый", ЭтотОбъект.ЭтоНовый());
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЭтотОбъект.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоНовыйЭлемент = ЗначениеДопСвойства("ЭтоНовый", Ложь);
	
	Если ЭтоНовыйЭлемент Тогда
		МенеджерЗаписи = РегистрыСведений.БЗ_СтатистикаНовостейБазыЗнаний.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Новость		= ЭтотОбъект.Ссылка;
		МенеджерЗаписи.Создана		= ЭтотОбъект.Дата;
		МенеджерЗаписи.Просмотры	= 0;
		МенеджерЗаписи.Комментарии	= 0;
		МенеджерЗаписи.Записать(Истина);
	КонецЕсли;
	
КонецПроцедуры

