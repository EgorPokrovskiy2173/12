Функция ДанныеФайлаДляОткрытия(ФайлСсылка, ВерсияСсылка, ИдентификаторФормы = Неопределено,
	РабочийКаталогВладельца = Неопределено, ПредыдущийАдресФайла = Неопределено) Экспорт
	
	ЕстьПраваНаОбъект = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ФайлСсылка, "Ссылка", Истина);
	Если ЕстьПраваНаОбъект = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ПредыдущийАдресФайла <> Неопределено Тогда
		Если НЕ ПустаяСтрока(ПредыдущийАдресФайла) И ЭтоАдресВременногоХранилища(ПредыдущийАдресФайла) Тогда
			УдалитьИзВременногоХранилища(ПредыдущийАдресФайла);
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВерсияСсылка) 
		И ОбщегоНазначения.ЕстьРеквизитОбъекта("ТекущаяВерсия", Метаданные.НайтиПоТипу(ТипЗнч(ФайлСсылка)))
		И ЗначениеЗаполнено(ФайлСсылка.ТекущаяВерсия) Тогда
		
		ВерсияСсылка = ФайлСсылка.ТекущаяВерсия;
	КонецЕсли;

	ДанныеФайла = ДанныеФайла(ФайлСсылка, ВерсияСсылка, ИдентификаторФормы);
	Если РабочийКаталогВладельца = Неопределено Тогда
		РабочийКаталогВладельца = РаботаСФайламиСлужебныйВызовСервера.РабочийКаталогПапки(ДанныеФайла.Владелец);
	КонецЕсли;
	ДанныеФайла.Вставить("РабочийКаталогВладельца", РабочийКаталогВладельца);
	
	Если ДанныеФайла.РабочийКаталогВладельца <> "" Тогда
		ИмяФайла = ОбщегоНазначенияКлиентСервер.ПолучитьИмяСРасширением(
			ДанныеФайла.ПолноеНаименованиеВерсии, ДанныеФайла.Расширение);
			ОбщегоНазначения.СократитьИмяФайла(ИмяФайла);
		ПолноеИмяФайлаВРабочемКаталоге = РабочийКаталогВладельца + ИмяФайла;
		ДанныеФайла.Вставить("ПолноеИмяФайлаВРабочемКаталоге", ПолноеИмяФайлаВРабочемКаталоге);
	КонецЕсли;
	
	СведенияОВерсии = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеФайла.Версия,
		"ТипХраненияФайла, Том, ПутьКФайлу");
	
	Если ДанныеФайла.Версия <> Неопределено
		И СведенияОВерсии.ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВТомахНаДиске Тогда
		
		ДвоичныеДанные = БЗ_РаботаСФайламиВТомахСлужебный.ДанныеФайла(ДанныеФайла.Версия);
		ДанныеФайла.НавигационнаяСсылкаТекущейВерсии = ПоместитьВоВременноеХранилище(ДвоичныеДанные, ИдентификаторФормы);
		
	КонецЕсли;
	
	ПредыдущийАдресФайла = ДанныеФайла.НавигационнаяСсылкаТекущейВерсии;
	Возврат ДанныеФайла;
	
КонецФункции

// Возвращает структуру, содержащую различные сведения о файле и версии.
//
// Параметры:
//  ФайлИлиВерсияСсылка  - СправочникСсылка.Файлы
//                       - СправочникСсылка.ВерсииФайлов - файл или версия файла.
//
// Возвращаемое значение:
//   Структура:
//     * Ссылка - ОпределяемыйТип.ПрисоединенныйФайл
//     * Версия - СправочникСсылка.ВерсииФайлов
//     * Расширение - Строка
//
Функция ДанныеФайла(ФайлСсылка, ВерсияСсылка = Неопределено, ИдентификаторФормы = Неопределено, Знач ВызыватьИсключение = Истина) Экспорт
	
	ЕстьПраваНаОбъект = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ФайлСсылка, "Ссылка", Истина);
	
	Если ЕстьПраваНаОбъект = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ФайлСсылка);
	
	ФайлОбъект = ФайлСсылка.ПолучитьОбъект();
	
	ДанныеФайла = Новый Структура;
	ДанныеФайла.Вставить("Ссылка", ФайлОбъект.Ссылка);
	ДанныеФайла.Вставить("Редактирует", ФайлОбъект.Редактирует);
	ДанныеФайла.Вставить("Владелец", ФайлОбъект.ВладелецФайла);
	
	МетаданныеОбъектаФайла = Метаданные.НайтиПоТипу(ТипЗнч(ФайлСсылка));
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ТекущаяВерсия", МетаданныеОбъектаФайла) И ЗначениеЗаполнено(ФайлСсылка.ТекущаяВерсия) Тогда
		ТекущаяВерсияФайла = ФайлОбъект.ТекущаяВерсия;
		// Без возможности хранить версии.
	Иначе
		ТекущаяВерсияФайла = ФайлСсылка;
	КонецЕсли;
	
	Если ВерсияСсылка <> Неопределено Тогда
		ДанныеФайла.Вставить("Версия", ВерсияСсылка);
	Иначе
		ДанныеФайла.Вставить("Версия", ТекущаяВерсияФайла);
	КонецЕсли;
	
	ДанныеФайла.Вставить("ТекущаяВерсия", ТекущаяВерсияФайла);
	ДанныеФайла.Вставить("ХранитьВерсии", ФайлОбъект.ХранитьВерсии);
	ДанныеФайла.Вставить("ПометкаУдаления", ФайлОбъект.ПометкаУдаления);
	ДанныеФайла.Вставить("Зашифрован", ФайлОбъект.Зашифрован);
	ДанныеФайла.Вставить("ПодписанЭП", ФайлОбъект.ПодписанЭП);
	ДанныеФайла.Вставить("ДатаЗаема", ФайлОбъект.ДатаЗаема);
	
	Если ВерсияСсылка = Неопределено Тогда
		ДанныеФайла.Вставить("СсылкаНаДвоичныеДанныеФайла",
		ПоместитьВоВременноеХранилище(РаботаСФайлами.ДвоичныеДанныеФайла(ФайлСсылка, ВызыватьИсключение), ИдентификаторФормы));
		ДанныеФайла.Вставить("НавигационнаяСсылка", ПолучитьНавигационнуюСсылку(ФайлСсылка));
		ДанныеФайла.Вставить("АвторТекущейВерсии", ФайлСсылка.Изменил);
		ДанныеФайла.Вставить("Кодировка", РегистрыСведений.БЗ_КодировкиФайлов.ОпределитьКодировкуФайла(ФайлСсылка, ФайлОбъект.Расширение));
	Иначе
		ДанныеФайла.Вставить("СсылкаНаДвоичныеДанныеФайла",
		ПоместитьВоВременноеХранилище(РаботаСФайлами.ДвоичныеДанныеФайла(ВерсияСсылка, ВызыватьИсключение), ИдентификаторФормы));
		ДанныеФайла.Вставить("НавигационнаяСсылка", ПолучитьНавигационнуюСсылку(ФайлОбъект.Ссылка));
		ДанныеФайла.Вставить("АвторТекущейВерсии", ВерсияСсылка.Автор);
		ДанныеФайла.Вставить("Кодировка", РегистрыСведений.БЗ_КодировкиФайлов.ОпределитьКодировкуФайла(ВерсияСсылка, ФайлОбъект.Расширение));
	КонецЕсли;
	
	Если ДанныеФайла.Зашифрован Тогда
		
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЭлектроннаяПодпись") Тогда
			МодульЭлектроннаяПодпись = ОбщегоНазначения.ОбщийМодуль("ЭлектроннаяПодпись");
			МассивСертификатовШифрования = МодульЭлектроннаяПодпись.СертификатыШифрования(ДанныеФайла.Ссылка);
		Иначе
			МассивСертификатовШифрования = Неопределено;
		КонецЕсли;
		
		ДанныеФайла.Вставить("МассивСертификатовШифрования", МассивСертификатовШифрования);
		
	КонецЕсли;
	
	ДанныеФайла.Вставить("Служебный", Ложь);
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(ФайлОбъект, "Служебный") Тогда
		ДанныеФайла.Служебный = ФайлОбъект.Служебный;
	КонецЕсли;
	
	РаботаСФайламиСлужебный.ЗаполнитьДополнительныеДанныеФайла(ДанныеФайла, ФайлОбъект, ВерсияСсылка);
	Возврат ДанныеФайла;
	
КонецФункции

Функция ПолучитьДанныеФайла(Знач ПрисоединенныйФайл,
	Знач ИдентификаторФормы = Неопределено,
	Знач ПолучатьСсылкуНаДвоичныеДанные = Истина,
	Знач ДляРедактирования = Ложь) Экспорт
	
	Возврат РаботаСФайлами.ДанныеФайла(ПрисоединенныйФайл, 
	ИдентификаторФормы,
	ПолучатьСсылкуНаДвоичныеДанные,
	ДляРедактирования);
КонецФункции

// Находит в регистре сведений ФайлыВРабочемКаталоге информацию о ВерсииФайла: путь к файлу версии в рабочем каталоге,
// и статус - на чтение или на редактирование.
// 
// Параметры:
//  Версия - СправочникСсылка.ВерсииФайлов - версия.
//  ИмяКаталога - путь рабочего каталога.
//  ВРабочемКаталогеНаЧтение - Булево - файл помещен на чтение.
//  ВРабочемКаталогеВладельца - Булево - файл в рабочем каталоге владельца (а не в основном рабочем каталоге).
//
Функция ПолноеИмяФайлаВРабочемКаталоге(Знач Версия, Знач ИмяКаталога, 
	ВРабочемКаталогеНаЧтение, ВРабочемКаталогеВладельца) Экспорт
	
	ЕстьПраваНаОбъект = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Версия, "Ссылка", Истина);
	Если ЕстьПраваНаОбъект = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	УстановитьОтключениеБезопасногоРежима(Истина);
	УстановитьПривилегированныйРежим(Истина);
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("Файл", Версия.Ссылка);
	СтруктураОтбора.Вставить("Пользователь", Пользователи.АвторизованныйПользователь());

	СтруктураРесурсов = РегистрыСведений.БЗ_ФайлыВРабочемКаталоге.Получить(СтруктураОтбора);
	ПолноеИмяФайла = СтруктураРесурсов.Путь;
	ВРабочемКаталогеНаЧтение = СтруктураРесурсов.НаЧтение;
	ВРабочемКаталогеВладельца = СтруктураРесурсов.ВРабочемКаталогеВладельца;
	Если ПолноеИмяФайла <> "" И ВРабочемКаталогеВладельца = Ложь Тогда
		ОбщегоНазначения.СократитьИмяФайла(ПолноеИмяФайла);
		ПолноеИмяФайла = ИмяКаталога + ОбщегоНазначенияКлиентСервер.ПолучитьИмяСРасширением(ПолноеИмяФайла, "");
	КонецЕсли;
	
	Возврат ПолноеИмяФайла;
	
КонецФункции

