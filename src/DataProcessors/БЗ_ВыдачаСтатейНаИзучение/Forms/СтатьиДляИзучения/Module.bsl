
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекПользователь = ПараметрыСеанса.ТекущийПользователь;
	Пользователь = ТекПользователь;
	Список.Параметры.УстановитьЗначениеПараметра("Пользователь", Пользователь);
	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", ТекущаяДата());
	
	//+++ АйТи Матвеичев П.С. 14.02.2022 ТЗ № ИС00-000443 >> e1cib/data/Документ.ЗаданиеНаРаботу?ref=a914fc3497141b3f11ec7d04818b6bad
    //КонтрольИзученияСтатейБазыЗнаний = РольДоступна("ПолныеПрава") ИЛИ РольДоступна("АйТи_КонтрольИзученияСтатейБазыЗнаний");
    КонтрольИзученияСтатейБазыЗнаний = КонтрольИзученияСтатейБазыЗнаний();
	//--- АйТи Матвеичев П.С. 14.02.2022 ТЗ № ИС00-000443 >> e1cib/data/Документ.ЗаданиеНаРаботу?ref=a914fc3497141b3f11ec7d04818b6bad
		
	Элементы.ВыдатьСтатьиНаИзучение.Видимость = Ложь;
	Элементы.ВыдатьСтатьиНаИзучениеНесколькимПользователям.Видимость = КонтрольИзученияСтатейБазыЗнаний;
	Элементы.Пользователь.Видимость = КонтрольИзученияСтатейБазыЗнаний;
	Элементы.СписокИзучениеСтатьиПроверено.Видимость = КонтрольИзученияСтатейБазыЗнаний;
	
	РегистрыСведений.БЗ_СостояниеСтатейБазыЗнаний.УстановитьУсловноеОформлениеСписка(Список.УсловноеОформление.Элементы);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ВидОтбора = "НеИзученные";
	УстановитьОтборСписка();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборСписка()
	
	Список.Отбор.Элементы.Очистить();
	
	Если ВидОтбора = "НеИзученные" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Изучена_Булево", Ложь, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	ИначеЕсли ВидОтбора = "Изученные" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Изучена_Булево", Истина, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	ИначеЕсли ВидОтбора = "ВсеНеПроверенные" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ПровереноИзучение_Булево", Ложь, ВидСравненияКомпоновкиДанных.Равно,, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Изучена_Булево", Истина, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	ИначеЕсли ВидОтбора = "ВсеНеПроверенные" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ПровереноИзучение_Булево", Ложь, ВидСравненияКомпоновкиДанных.Равно,, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Изучена_Булево", Истина, ВидСравненияКомпоновкиДанных.Равно,, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ВыдалНаИзучение", ТекПользователь, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Изучена_Булево",,,, Ложь);
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ПользовательПриИзменении(Элемент)
	Если НЕ ЗначениеЗаполнено(Пользователь) Тогда
		Пользователь = ТекПользователь;
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("Пользователь", Пользователь);
	Элементы.ВыдатьСтатьиНаИзучение.Видимость = КонтрольИзученияСтатейБазыЗнаний И Пользователь <> ТекПользователь;
КонецПроцедуры

&НаКлиенте
Процедура ВидОтбораПриИзменении(Элемент)
	УстановитьОтборСписка();
КонецПроцедуры

&НаКлиенте
Процедура ВыдатьСтатьиНаИзучение(Команда)
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("ПользовательДляПодбора", Пользователь);
	
	ОП = Новый ОписаниеОповещения("ПослеНазначениеСтатейДляИзучения", ЭтаФорма);
	
	ОткрытьФорму("Справочник.БЗ_СтатьиБазыЗнаний.Форма.НазначениеСтатейДляИзучения", ПараметрыОткрытияФормы, ЭтаФорма,,,, ОП, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ВыдатьСтатьиНаИзучениеНесколькимПользователям(Команда)
	ОП = Новый ОписаниеОповещения("ПослеНазначениеСтатейДляИзучения", ЭтаФорма);
	ОткрытьФорму("Справочник.БЗ_СтатьиБазыЗнаний.Форма.НазначениеСтатейДляИзучения",, ЭтаФорма,,,, ОП, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте                                                          
Процедура ПослеНазначениеСтатейДляИзучения(Результат, ДопПараметры) Экспорт
	//Элементы.Список.Обновить();
КонецПроцедуры // ()


&НаКлиенте
Процедура ИзучениеСтатьиПроверено(Команда)
	
	ТекДанные = Элементы.Список.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		ЗаписатьИзучениеСтатьиПроверено(ТекДанные.СтатьяБазыЗнаний, Пользователь);
		ОповеститьОбИзменении(Тип("РегистрСведенийКлючЗаписи.БЗ_СостояниеСтатейБазыЗнаний"));
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписатьИзучениеСтатьиПроверено(СтатьяБазыЗнаний, Пользователь)
	
	НаборЗаписей = РегистрыСведений.БЗ_СостояниеСтатейБазыЗнаний.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.СтатьяБазыЗнаний.Установить(СтатьяБазыЗнаний);
	НаборЗаписей.Отбор.Пользователь.Установить(Пользователь);
	НаборЗаписей.Прочитать();
	
	ЗаписьРегистра = НаборЗаписей[0];
	ЗаписьРегистра.ПровереноИзучение = ТекущаяДата();
	
	НаборЗаписей.Записать();
	
КонецПроцедуры // ЗаписатьИзучениеСтатьиПроверено()


&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ТекДанные = Элементы.Список.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		Элементы.СписокИзучениеСтатьиПроверено.Видимость = ТекДанные.Изучена_Булево И НЕ ТекДанные.ПровереноИзучение_Булево И (КонтрольИзученияСтатейБазыЗнаний() ИЛИ ТекПользователь = ТекДанные.ВыдалНаИзучение ИЛИ НЕ ЗначениеЗаполнено(ТекДанные.ВыдалНаИзучение));
	КонецЕсли;
	
КонецПроцедуры

//+++ АйТи Матвеичев П.С. 14.02.2022 ТЗ № ИС00-000443 >> e1cib/data/Документ.ЗаданиеНаРаботу?ref=a914fc3497141b3f11ec7d04818b6bad
&НаСервере
Функция КонтрольИзученияСтатейБазыЗнаний()

	Возврат РольДоступна("ПолныеПрава") ИЛИ РольДоступна("БЗ_КонтрольИзученияСтатейБазыЗнаний");		

КонецФункции

//--- АйТи Матвеичев П.С. 14.02.2022 ТЗ № ИС00-000443 >> e1cib/data/Документ.ЗаданиеНаРаботу?ref=a914fc3497141b3f11ec7d04818b6bad

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ТекДанные = Элементы.Список.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		ПоказатьЗначение(, ТекДанные.СтатьяБазыЗнаний);
	КонецЕсли;
	
КонецПроцедуры



