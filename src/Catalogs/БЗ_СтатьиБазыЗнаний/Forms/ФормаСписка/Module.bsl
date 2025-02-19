////////////////////////////////////////////////////////////////////////////////
// УПРАВЛЕНИЕ ФОРМОЙ

&НаКлиенте
Процедура УстановитьДоступностьКнопокБлокировки(РедакторСтатьи = Неопределено)
	ДоступностьЗахвата		= Ложь;
	ДоступностьОсвобождения	= Ложь;
	
	Если НЕ ЗначениеЗаполнено(РедакторСтатьи) Тогда
		ДоступностьЗахвата = Истина;
	КонецЕсли;
	Если РедакторСтатьи = ТекущийПользователь ИЛИ РедакторСтатьи = Администратор Тогда
		ДоступностьОсвобождения = Истина;
	КонецЕсли;
	
	Элементы.ЗахватитьНаРедактирование.Доступность		= ДоступностьЗахвата;
	Элементы.МенюЗахватитьНаРедактирование.Доступность	= ДоступностьЗахвата;
	Элементы.ЗавершитьРедактирование.Доступность		= ДоступностьОсвобождения;
	Элементы.МенюЗавершитьРедактирование.Доступность	= ДоступностьОсвобождения;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТКА СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьДоступностьКнопокБлокировки(ТекущиеДанные.Редактор);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТКА СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	Администратор		= БЗ_БазаЗнанийВызовСервера.ПолучитьЗначениеНастройки("Администратор");

	//+++ АйТи Кучеров Р.М. 07.10.2020 ТЗ № ИС00-003398 >> e1cib/data/Документ.ЗаданиеНаРаботу?ref=82a932336337376211eb089480e29675
	Если Параметры.Свойство("ИмяОбъекта") Тогда
		ОбъектМетаданных = НайтиОбъектМетаданныхНаСервере(Параметры.ИмяОбъекта);
		пСсылкиНаСтатьи = Новый СписокЗначений;
		
		Если ЗначениеЗаполнено(ОбъектМетаданных) Тогда
			Запрос = Новый Запрос("ВЫБРАТЬ
			|	Таб.Статья КАК Статья,
			|	Таб.Объект1С КАК Объект1С
			|ИЗ
			|	РегистрСведений.БЗ_ПривязкиОбъектов1СКСтатьямБазыЗнаний КАК Таб
			|ГДЕ
			|	Таб.Объект1С = &Объект1С");
			
			Запрос.УстановитьПараметр("Объект1С", ОбъектМетаданных);
			
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				пСсылкиНаСтатьи.Добавить(Выборка.Статья);
			КонецЦикла;
			
			Заголовок = "Статьи базы знаний для " + СокрЛП(ОбъектМетаданных);
		КонецЕсли;	
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ссылка", пСсылкиНаСтатьи, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);
		
	КонецЕсли;
	//--- АйТи Кучеров Р.М. 07.10.2020 ТЗ № ИС00-003398 >> e1cib/data/Документ.ЗаданиеНаРаботу?ref=82a932336337376211eb089480e29675
	
КонецПроцедуры

//+++ АйТи Кучеров Р.М. 07.10.2020 ТЗ № ИС00-003398 >> e1cib/data/Документ.ЗаданиеНаРаботу?ref=82a932336337376211eb089480e29675
Функция НайтиОбъектМетаданныхНаСервере(ИмяОбъекта)
	
	ВозвращаемоеЗначение = Справочники.ИдентификаторыОбъектовМетаданных.НайтиПоРеквизиту("ПолноеИмя", ИмяОбъекта);
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции
//--- АйТи Кучеров Р.М. 07.10.2020 ТЗ № ИС00-003398 >> e1cib/data/Документ.ЗаданиеНаРаботу?ref=82a932336337376211eb089480e29675

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТКА КОМАНД ФОРМЫ

&НаКлиенте
Процедура ЗахватитьНаРедактирование(Команда)
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ЗахватитьНаРедактированиеНаСервере(ТекущиеДанные.Ссылка);
	
	Элементы.Список.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРедактированиеАдминистратором(Результат, ДопПараметры)
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ЗавершитьРедактированиеНаСервере(ДопПараметры.Статья);
	
	Элементы.Список.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДопПараметры = Новый Структура("Статья", ТекущиеДанные.Ссылка);
	Если ЗначениеЗаполнено(ТекущиеДанные.Редактор)
		И ТекущиеДанные.Редактор <> ТекущийПользователь Тогда
		
		Если ТекущийПользователь = Администратор Тогда
			ОбработкаОповещения	= Новый ОписаниеОповещения("ЗавершитьРедактированиеАдминистратором", ЭтотОбъект, ДопПараметры);
			ТекстВопроса		= НСтр("ru='При завершении редактирования администратором возможна потеря данных в параллельных сессиях.
			|Вы уверены что хотите продолжить?'");
			
			ПоказатьВопрос(ОбработкаОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет, , КодВозвратаДиалога.Нет);
		Иначе 
			Возврат;
		КонецЕсли;
	Иначе 
		ЗавершитьРедактированиеАдминистратором(КодВозвратаДиалога.Да, ДопПараметры);
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ МЕТОДЫ

&НаСервереБезКонтекста
Функция ЗахватитьНаРедактированиеНаСервере(СтатьяСсылка)
	Возврат Справочники.БЗ_СтатьиБазыЗнаний.ЗахватитьСтатьюНаРедактирование(СтатьяСсылка);
КонецФункции

&НаСервереБезКонтекста
Функция ЗавершитьРедактированиеНаСервере(СтатьяСсылка)
	Возврат Справочники.БЗ_СтатьиБазыЗнаний.ЗавершитьРедактированиеСтатьи(СтатьяСсылка);
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ НАСТРОЙКИ ПОРЯДКА ЭЛЕМЕНТОВ

&НаКлиенте
Процедура ПереместитьЭлементВверх(Команда)
	//+++ АйТи Кучеров Р.М. 07.10.2020 ТЗ № ИС00-003398 >> e1cib/data/Документ.ЗаданиеНаРаботу?ref=82a932336337376211eb089480e29675
	//НастройкаПорядкаЭлементовКлиент.ПереместитьЭлементВверхВыполнить(Список, Элементы.Список);
	//--- АйТи Кучеров Р.М. 07.10.2020 ТЗ № ИС00-003398 >> e1cib/data/Документ.ЗаданиеНаРаботу?ref=82a932336337376211eb089480e29675
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьЭлементВниз(Команда)
	//+++ АйТи Кучеров Р.М. 07.10.2020 ТЗ № ИС00-003398 >> e1cib/data/Документ.ЗаданиеНаРаботу?ref=82a932336337376211eb089480e29675
	//НастройкаПорядкаЭлементовКлиент.ПереместитьЭлементВнизВыполнить(Список, Элементы.Список);
	//--- АйТи Кучеров Р.М. 07.10.2020 ТЗ № ИС00-003398 >> e1cib/data/Документ.ЗаданиеНаРаботу?ref=82a932336337376211eb089480e29675
КонецПроцедуры


&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	а = 1;
КонецПроцедуры

