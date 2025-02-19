#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

///////////////////////////////////////////////////////
Процедура СоздатьКаталогНаСервере (ИмяКаталога,Отказ,Сообщение) Экспорт
	Попытка
		СоздатьКаталог(ИмяКаталога);
	Исключение
	   	Сообщение=ОписаниеОшибки();
		Отказ=Истина;
	КонецПопытки; 
КонецПроцедуры

Процедура УдалитьФайлыНаСервере(ПапкаДляУдаления,ИмяФайла,Отказ,Сообщение) Экспорт
	Попытка
		УдалитьФайлы(ПапкаДляУдаления,ИмяФайла); //удалить файл
		//если папка пуста, то удалить папку
		л_МассивОставшихсяФайлов=НайтиФайлы(ПапкаДляУдаления,"*.*",Ложь);
		Если л_МассивОставшихсяФайлов.ВГраница() = -1 Тогда 
			УдалитьФайлы(ПапкаДляУдаления);
		КонецЕсли;
	Исключение
		Отказ=Истина;
	    Сообщение=ОписаниеОшибки();
	КонецПопытки;
КонецПроцедуры

Процедура СохранитьФайлНаСервере (ВнутреннийАдресСервера,ПолноеИмяСохраняемогоФайла) Экспорт
	л_ДвоичныеДанныеФайла=ПолучитьИзВременногоХранилища(ВнутреннийАдресСервера);
	л_ДвоичныеДанныеФайла.Записать(ПолноеИмяСохраняемогоФайла);
КонецПроцедуры // СохранитьФайлНаСервере()
///////////////////////////////////////////////////////

Функция ПолучитьКлючЗаписи(Ссылка,ПараметрыФайла,Настройка="")Экспорт
	л_Отбор=Новый Структура("ОбъектУИД,ОбъектСсылка,МестоХраненияФайлов,ИмяФайла,РасширениеИмениФайла");
	л_Ключ=СоздатьКлючЗаписи(л_Отбор);
	
	Если ПустаяСтрока(Настройка) Тогда 
		Настройка=РегистрыСведений.БЗ_НастройкаХраненияФайлов.ПолучитьПоследнее();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Ссылка) Тогда 
		л_Отбор.ОбъектУИД=Ссылка.УникальныйИдентификатор();
		л_Отбор.ОбъектСсылка=Ссылка;
		л_Отбор.МестоХраненияФайлов=Настройка.МестоХраненияФайлов;
		л_Отбор.ИмяФайла=ПараметрыФайла.ИмяБезРасширения;
		л_Отбор.РасширениеИмениФайла=ПараметрыФайла.Расширение;
		л_Ключ=СоздатьКлючЗаписи(л_Отбор);
	КонецЕсли;

	Возврат л_Ключ;
КонецФункции // ПолучитьКлючЗаписи(Ссылка,ИмяФайла)()

Функция ПолучитьЗапись(Ключ)Экспорт 
	л_Запись=СоздатьМенеджерЗаписи();
	л_Запрос=Новый Запрос;
	л_Запрос.Текст=
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ХранилищеФайловСрезПоследних.Период КАК Период,
	|	ХранилищеФайловСрезПоследних.ОбъектУИД КАК ОбъектУИД,
	|	ХранилищеФайловСрезПоследних.ОбъектСсылка КАК ОбъектСсылка,
	|	ХранилищеФайловСрезПоследних.МестоХраненияФайлов КАК МестоХраненияФайлов,
	|	ХранилищеФайловСрезПоследних.ИмяФайла КАК ИмяФайла,
	|	ХранилищеФайловСрезПоследних.РасширениеИмениФайла КАК РасширениеИмениФайла,
	|	ХранилищеФайловСрезПоследних.Автор КАК Автор,
	|	ХранилищеФайловСрезПоследних.ХранилищеДвоичныхДанных КАК ХранилищеДвоичныхДанных,
	|	ХранилищеФайловСрезПоследних.ПутьФайла КАК ПутьФайла
	|ИЗ
	|	РегистрСведений.БЗ_ХранилищеФайлов.СрезПоследних(
	|			&НаДату,
	|			ИмяФайла = &ИмяФайла
	|				И МестоХраненияФайлов = &МестоХраненияФайлов
	|				И ОбъектУИД = &ОбъектУИД
	|				И ОбъектСсылка = &ОбъектСсылка) КАК ХранилищеФайловСрезПоследних";
	л_Запрос.УстановитьПараметр("ИмяФайла",Ключ.ИмяФайла);
	л_Запрос.УстановитьПараметр("МестоХраненияФайлов",Ключ.МестоХраненияФайлов);
	л_Запрос.УстановитьПараметр("ОбъектУИД",Ключ.ОбъектУИД);
	л_Запрос.УстановитьПараметр("ОбъектСсылка",Ключ.ОбъектСсылка);
	л_Запрос.УстановитьПараметр("НаДату",ТекущаяДата());
	л_Рез=л_Запрос.Выполнить().Выгрузить();
	
	Если л_Рез.Количество() > 0 Тогда 
		ЗаполнитьЗначенияСвойств(л_Запись,л_Рез[0]);
		л_Запись.Прочитать();
	КонецЕсли;
	
	Возврат л_Запись;
КонецФункции // ПолучитьЗапись()

Функция ПолучитьСтрокуФайлов(Ссылка)Экспорт 
	л_Строка="";
	л_Запрос=Новый Запрос;
	л_Запрос.Текст=
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ХранилищеФайлов.ИмяФайла КАК ИмяФайла,
	|	ХранилищеФайлов.РасширениеИмениФайла КАК РасширениеИмениФайла
	|ИЗ
	|	РегистрСведений.БЗ_ХранилищеФайлов КАК ХранилищеФайлов
	|ГДЕ
	|	ХранилищеФайлов.ОбъектСсылка = &ОбъектСсылка";
	л_Запрос.УстановитьПараметр("ОбъектСсылка",Ссылка);
	л_ТЗ=л_Запрос.Выполнить().Выгрузить();
	Для Каждого л_Стр Из л_ТЗ Цикл 
		л_Строка=л_Строка+л_Стр[0]+л_Стр[1]+"; ";
	КонецЦикла;
	Возврат Лев(л_Строка,СтрДлина(л_Строка)-СтрДлина("; "));
КонецФункции // ПолучитьСтрокуФайлов()

//добавление (загрузка) файлов на диск сервера
Процедура СохранитьФайлНаДиск(Знач АдресВременногоХранилища,знач п_НастройкаХраненияФайлов,знач п_Объект,п_Файл,п_Отказ,Сообщение="")Экспорт
		
	//получить имя общей папки на сервере
	л_ОбщаяПапка=п_НастройкаХраненияФайлов.КаталогФайлов;
	Если Прав(л_ОбщаяПапка,1) = "\" Тогда 
		л_ПапкаОбъекта=л_ОбщаяПапка+Формат(ТекущаяДата(), "ДФ=""ггггММдд""")+"\"+п_Объект.УникальныйИдентификатор();
	Иначе 
		л_ПапкаОбъекта=л_ОбщаяПапка+"\"+Формат(ТекущаяДата(), "ДФ=""ггггММдд""")+"\"+п_Объект.УникальныйИдентификатор();
	КонецЕсли;
	
	//Создать папку, если такой не существует
	СоздатьКаталогНаСервере (л_ПапкаОбъекта,п_Отказ,Сообщение);
	Если п_Отказ Тогда 
		Возврат;
	КонецЕсли;
	
	//получить полное имя файла на сервере
	л_ПолноеИмяСохраняемогоФайла=л_ПапкаОбъекта+"\"+п_Файл.Имя;
	
	//проверить существование такого файла на сервере
	л_СохраняемыйФайл=Новый Файл(л_ПолноеИмяСохраняемогоФайла);
	Если л_СохраняемыйФайл.Существует() Тогда 
		Сообщение="Файл с именем """+п_Файл.Имя+""" уже существует";
		п_Отказ=Истина;
		Возврат;
	КонецЕсли;

 	//копировать файл из временного хранилища базы на диск сервера
	Попытка
		СохранитьФайлНаСервере (АдресВременногоХранилища,л_ПолноеИмяСохраняемогоФайла);
		п_Файл.ПолноеИмя=л_ПолноеИмяСохраняемогоФайла;
		п_Файл.Путь=л_ПапкаОбъекта;
	Исключение
		Сообщение=ОписаниеОшибки();
		п_Отказ=Истина;
	КонецПопытки;
	
КонецПроцедуры

Процедура ПоместитьФайлВоВременноеХранилище(Знач КлючЗаписи,АдресХранилища) 
	
	л_Запись=ПолучитьЗапись(КлючЗаписи);
	
	Если л_Запись.МестоХраненияФайлов = Перечисления.БЗ_МестоХраненияПрикрепленныхФайлов.ИнформационнаяБаза Тогда 
		
		л_ДвоичныеДанныеФайла=л_Запись.ХранилищеДвоичныхДанных.Получить();
		АдресХранилища=ПоместитьВоВременноеХранилище(л_ДвоичныеДанныеФайла);
		
	ИначеЕсли л_Запись.МестоХраненияФайлов = Перечисления.БЗ_МестоХраненияПрикрепленныхФайлов.ОбщийДисковыйРесурс Тогда 
		
		л_НастройкаХраненияФайлов=РегистрыСведений.БЗ_НастройкаХраненияФайлов.ПолучитьПоследнее(л_Запись.Период);
		Если ЗначениеЗаполнено(л_НастройкаХраненияФайлов) Тогда 
			л_ПолноеИмяФайла=л_Запись.ПутьФайла+"\"+л_Запись.ИмяФайла+л_Запись.РасширениеИмениФайла; //л_НастройкаХраненияФайлов.КаталогФайлов+"\"+л_Запись.Объект+"\"+л_Запись.ИмяФайла+л_Запись.РасширениеИмениФайла;
			АдресХранилища=ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(л_ПолноеИмяФайла));
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьАдресФайлаВоВременномХранилище(Знач КлючЗаписи)Экспорт 
	л_Адрес="";
	ПоместитьФайлВоВременноеХранилище(КлючЗаписи,л_Адрес);
	Возврат л_Адрес;
КонецФункции 

Процедура ДобавитьЗаписьВРегистр(знач ДатаЗагрузки,знач п_ОбъектСсылка,знач п_Файл,знач п_НастройкаХраненияФайлов,п_Отказ,п_ИзменитьСуществующуюЗапись=Ложь,п_Запись="",Сообщение="", п_АдресВременногоХранилища = Неопределено)Экспорт 
	
		л_Запись=СоздатьМенеджерЗаписи();
		
		л_МестоХраненияФайлов=п_НастройкаХраненияФайлов.МестоХраненияФайлов;
		Если п_ИзменитьСуществующуюЗапись Тогда 
			л_Запись=п_Запись;
		Иначе 
			л_Запись.Период=ДатаЗагрузки;
			л_Запись.Активность=Истина;
			л_Запись.ОбъектУИД=п_ОбъектСсылка.УникальныйИдентификатор();
			л_Запись.ОбъектСсылка=п_ОбъектСсылка;
			л_Запись.ИмяФайла=п_Файл.ИмяБезРасширения;
			л_Запись.МестоХраненияФайлов=л_МестоХраненияФайлов;
			л_Запись.РасширениеИмениФайла=п_Файл.Расширение;
			л_Запись.Автор=ПараметрыСеанса.ТекущийПользователь;
			л_Запись.ПутьФайла=п_Файл.Путь;
		КонецЕсли;
	
		Если л_МестоХраненияФайлов = Перечисления.БЗ_МестоХраненияПрикрепленныхФайлов.ИнформационнаяБаза Тогда 
			
			Если ЗначениеЗаполнено(п_АдресВременногоХранилища) Тогда
				п_ДвоичныеДанныеФайлаНаСервере = ПолучитьИзВременногоХранилища(п_АдресВременногоХранилища);
			Иначе
				п_ДвоичныеДанныеФайлаНаСервере = Неопределено;
			КонецЕсли;
			
			Если п_НастройкаХраненияФайлов.ИспользоватьСжатие Тогда 
				л_Запись.ХранилищеДвоичныхДанных = Новый ХранилищеЗначения(?(п_ДвоичныеДанныеФайлаНаСервере = Неопределено, Новый ДвоичныеДанные (п_Файл.ПолноеИмя), п_ДвоичныеДанныеФайлаНаСервере),Новый СжатиеДанных(п_НастройкаХраненияФайлов.МетодСжатия));
			Иначе 
				л_Запись.ХранилищеДвоичныхДанных = Новый ХранилищеЗначения(?(п_ДвоичныеДанныеФайлаНаСервере = Неопределено, Новый ДвоичныеДанные (п_Файл.ПолноеИмя), п_ДвоичныеДанныеФайлаНаСервере));
			КонецЕсли;
		КонецЕсли;

		Попытка
			л_Запись.Записать(п_ИзменитьСуществующуюЗапись);
			п_Запись=л_Запись;
			Сообщение="Файл "+п_Файл.Имя+" успешно загружен!";
		Исключение
			п_Отказ=Истина;
			Сообщение="Ошибка в процедуре ""ДобавитьЗаписьВРегистр(...)"""+Символы.ПС+ОписаниеОшибки();
		КонецПопытки;
		
КонецПроцедуры

//Удаление файлов
Процедура УдалитьФайлСДиска(знач КлючЗаписи,Отказ,Сообщение="")Экспорт 
	л_Запись=ПолучитьЗапись(КлючЗаписи);	
	л_НастройкаХраненияФайлов=РегистрыСведений.БЗ_НастройкаХраненияФайлов.ПолучитьПоследнее(л_Запись.Период);
	л_ПапкаДляУдаления=л_Запись.ПутьФайла+"\"; //л_НастройкаХраненияФайлов.КаталогФайлов+"\"+л_Запись.Объект+"\";
	л_ИмяФайла=л_Запись.ИмяФайла+л_Запись.РасширениеИмениФайла;

	УдалитьФайлыНаСервере(л_ПапкаДляУдаления,л_ИмяФайла,Отказ,Сообщение);
	Если НЕ Отказ Тогда 
		Сообщение="Успешно удален файл "+л_ИмяФайла;
	КонецЕсли;;

КонецПроцедуры

Процедура УдалитьЗаписьИзРегистра(знач КлючЗаписи,Отказ,Сообщение="")Экспорт 
	л_Запись=ПолучитьЗапись(КлючЗаписи);
	Если л_Запись.Выбран() Тогда 
		л_Запись.Удалить();
	Иначе 
		Сообщение="Запись не найдена!";
		Отказ=Истина;
	КонецЕсли;
КонецПроцедуры

#КонецЕсли