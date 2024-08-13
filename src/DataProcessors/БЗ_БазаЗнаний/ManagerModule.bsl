Функция РаспаковатьПакетСКартинками()
	
	// Вставить содержимое метода.
	ВремКаталог	= КаталогВременныхФайлов();
	ВремКаталог = ВремКаталог + "kdb_pictures_6";
	
	//Тестф = Новый Файл(ВремКаталог + "TypeIconFile_1.png");
	//Тестф.Существует()
	//Тестф.ПолучитьТолькоЧтение()
	МассивФайлов = НайтиФайлы(ВремКаталог, "*");
	Для Каждого Файл Из МассивФайлов Цикл
		Файл.УстановитьТолькоЧтение(Ложь);
	КонецЦикла;
	УдалитьФайлы(ВремКаталог, "*");
	
	ВремФайл	= ПолучитьИмяВременногоФайла("zip");
	ВремКаталог	= КаталогВременныхФайлов();
	ВремКаталог = ВремКаталог + "kdb_pictures_6\";
	
	ДвоичныеДанные = Обработки.БЗ_БазаЗнаний.ПолучитьМакет("pictures_v1");
	ДвоичныеДанные.Записать(ВремФайл);
	
	Чтение = Новый ЧтениеZipФайла(ВремФайл);
	Чтение.ИзвлечьВсе(ВремКаталог, РежимВосстановленияПутейФайловZIP.Восстанавливать);
	Чтение.Закрыть();
	Чтение = Неопределено;
	
	УдалитьФайлы(ВремФайл);
	
	ВремФайл	= ПолучитьИмяВременногоФайла("zip");
	
	ДвоичныеДанные = Обработки.БЗ_БазаЗнаний.ПолучитьМакет("Pictures_FileType");
	ДвоичныеДанные.Записать(ВремФайл);
	
	Чтение = Новый ЧтениеZipФайла(ВремФайл);
	Чтение.ИзвлечьВсе(ВремКаталог, РежимВосстановленияПутейФайловZIP.Восстанавливать);
	Чтение.Закрыть();
	Чтение = Неопределено;
	
	УдалитьФайлы(ВремФайл);
	
	БиблиотекаКартинок.БЗ_ПолучитьСсылку.Записать(ВремКаталог + "it_link.png");
	БиблиотекаКартинок.БЗ_ПиктограммаПоказателяПриемлемоеЗначение.Записать(ВремКаталог + "it_jackdaw.png");
	БиблиотекаКартинок.ОформлениеКрест.Записать(ВремКаталог + "it_RedCross.png");
	БиблиотекаКартинок.БЗ_ОтсутствуетСогласие.Записать(ВремКаталог + "UpdatingIsRequired.png");
	//+++ АйТи Чириков В. А. 23.03.2023 ТЗ № ИС00-001047 >> e1cib/data/Документ.ЗаданиеНаРаботу?ref=a93bfc3497141b3f11eda38f7dd40ec4
	БиблиотекаКартинок.БЗ_Избранное.Записать(ВремКаталог + "star_low.png"); 
	//--- АйТи Чириков В. А. 23.03.2023 ТЗ № ИС00-001047 >> e1cib/data/Документ.ЗаданиеНаРаботу?ref=a93bfc3497141b3f11eda38f7dd40ec4
	
	Возврат ВремКаталог;
	
КонецФункции

Функция ПоместитьКартинкиБазыЗнанийВХранилище(МассивФайлов) Экспорт
	
	// Распакуем архив с картинками на сервере
	АдресКаталога = РаспаковатьПакетСКартинками();
	
	// Создадим массив передаваемых файлов на клиент
	МассивОписаний = Новый Массив;
	Для Каждого СтруктураКартинки Из МассивФайлов Цикл
		ФайлКартинки = Новый Файл(АдресКаталога + СтруктураКартинки.Имя);
		Если НЕ ФайлКартинки.Существует() Тогда
			Продолжить;
		КонецЕсли;
		ФайлКартинки.УстановитьТолькоЧтение(Ложь);
		
		ДвоичныеДанные	= Новый ДвоичныеДанные(АдресКаталога + СтруктураКартинки.Имя);
		АдресХранилища	= ПоместитьВоВременноеХранилище(ДвоичныеДанные);
		ДвоичныеДанные	= Неопределено;
		
		Если АдресХранилища = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ОписаниеФайла	= Новый ОписаниеПередаваемогоФайла(СтруктураКартинки.Путь, АдресХранилища);
		МассивОписаний.Добавить(ОписаниеФайла);
	КонецЦикла;
	
	// Удалим файлы
	Попытка
		УдалитьФайлы(АдресКаталога, "*");
	Исключение
	КонецПопытки;
	
	Возврат МассивОписаний;
	
КонецФункции

Функция ПоместитьСкриптыБазыЗнанийВХранилище(МассивСкриптов) Экспорт
	
	ИмяВремФайла		= ПолучитьИмяВременногоФайла("js");
	ОбработкаМенеджер	= Обработки.БЗ_БазаЗнаний;
	
	МассивОписаний = Новый Массив;
	Для Каждого СтруктураСкрипта Из МассивСкриптов Цикл
		ТекстовыйДокумент = ОбработкаМенеджер.ПолучитьМакет(СтруктураСкрипта.Имя);
		ТекстовыйДокумент.Записать(ИмяВремФайла);
		ДвоичныеДанные = Новый ДвоичныеДанные(ИмяВремФайла);
		АдресХранилища	= ПоместитьВоВременноеХранилище(ДвоичныеДанные);
		Если АдресХранилища = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ОписаниеФайла	= Новый ОписаниеПередаваемогоФайла(СтруктураСкрипта.Путь, АдресХранилища);
		МассивОписаний.Добавить(ОписаниеФайла);
	КонецЦикла;
	
	УдалитьФайлы(ИмяВремФайла);
	
	Возврат МассивОписаний;
	
КонецФункции

Функция ПолучитьТекстыСкриптов(МассивСкриптов) Экспорт
	
	ОбработкаМенеджер = Обработки.БЗ_БазаЗнаний;
	
	МассивОписаний = Новый Массив;
	Для Каждого СтруктураСкрипта Из МассивСкриптов Цикл
		ТекстовыйДокумент = ОбработкаМенеджер.ПолучитьМакет(СтруктураСкрипта.Имя);
		Если ТипЗнч(ТекстовыйДокумент) <> Тип("ТекстовыйДокумент") Тогда
			Продолжить;
		КонецЕсли;
		
		ТелоСкрипта = ТекстовыйДокумент.ПолучитьТекст();
		МассивОписаний.Добавить(ТелоСкрипта);
	КонецЦикла;
	
	Возврат МассивОписаний;
	
КонецФункции
