///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики обновления.

// Регистрирует на плане обмена ОбновлениеИнформационнойБазы объекты,
// для которых необходимо обновить записи в регистре.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаРегистров = "РегистрСведений.БЗ_СведенияОФайлах";
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиИзмеренияНезависимогоРегистраСведений();
	
	Файл = "";
	ОтработаныВсеЗаписиРегистра = Ложь;
	Пока Не ОтработаныВсеЗаписиРегистра Цикл
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1000
		|	СведенияОФайлах.Файл КАК Файл
		|ИЗ
		|	РегистрСведений.БЗ_СведенияОФайлах КАК СведенияОФайлах
		|ГДЕ
		|	СведенияОФайлах.Файл > &Файл
		|	И СведенияОФайлах.ТипХраненияФайла = ЗНАЧЕНИЕ(Перечисление.ТипыХраненияФайлов.ПустаяСсылка)";
		Запрос.УстановитьПараметр("Файл", Файл);
		ИзмеренияРегистра = Запрос.Выполнить().Выгрузить();
		
		ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
		ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
		ДополнительныеПараметры.ПолноеИмяРегистра = "РегистрСведений.БЗ_СведенияОФайлах";
		
		ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, ИзмеренияРегистра, ДополнительныеПараметры);
		
		КоличествоЗаписей = ИзмеренияРегистра.Количество();
		Если КоличествоЗаписей < 1000 Тогда
			ОтработаныВсеЗаписиРегистра = Истина;
		КонецЕсли;
		
		Если КоличествоЗаписей > 0 Тогда
			Файл = ИзмеренияРегистра[КоличествоЗаписей-1].Файл;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Обновить записи регистра.
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ВыбранныеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	ОбъектовОбработано = 0;
	ПроблемныхОбъектов = 0;
	
	Для Каждого Строка Из ВыбранныеДанные Цикл
		
		НачатьТранзакцию();
		Попытка
			
			БлокировкаДанных = Новый БлокировкаДанных;
			ЭлементБлокировкиДанных = БлокировкаДанных.Добавить(Строка.Файл.Метаданные().ПолноеИмя());
			ЭлементБлокировкиДанных.УстановитьЗначение("Ссылка", Строка.Файл);
			ЭлементБлокировкиДанных.Режим = РежимБлокировкиДанных.Разделяемый;
			
			ЭлементБлокировкиДанных = БлокировкаДанных.Добавить("РегистрСведений.БЗ_СведенияОФайлах");
			ЭлементБлокировкиДанных.УстановитьЗначение("Файл", Строка.Файл);
			
			БлокировкаДанных.Заблокировать();
			
			ТипХраненияФайла = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Строка.Файл, "ТипХраненияФайла");
			
			НаборЗаписей = РегистрыСведений.БЗ_СведенияОФайлах.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Файл.Установить(Строка.Файл);
			НаборЗаписей.Прочитать();
			
			Для Каждого СведенияОФайле Из НаборЗаписей Цикл
				СведенияОФайле.ТипХраненияФайла = ТипХраненияФайла;
			КонецЦикла;
			
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
			
			ОбъектовОбработано = ОбъектовОбработано + 1;
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обработать сведения о файле %1 по причине:
				|%2'"), 
				Строка.Файл, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				Строка.Файл.Метаданные(), Строка.Файл, ТекстСообщения);
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, "РегистрСведений.БЗ_СведенияОФайлах");
	
	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось обработать некоторые сведения о файлах (пропущены): %1'"), 
			ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,
			Метаданные.Справочники.БЗ_Файлы,,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Обработана очередная порция сведений о файлах: %1'"),
				ОбъектовОбработано));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
