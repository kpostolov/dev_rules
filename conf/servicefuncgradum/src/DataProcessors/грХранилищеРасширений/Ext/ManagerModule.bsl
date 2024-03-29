﻿//+++ Градум; Курпяев Е.Д. ; 22.03.2018; Трек UH0001_Подготовка конфигурации
Процедура ОбновитьРасширения( Параметр = Неопределено ) Экспорт
	
	Макеты = Метаданные.Обработки.грХранилищеРасширений.Макеты;
	ИменаМакетов = Новый Массив;
	
	Для каждого Макет Из Макеты Цикл
		ИменаМакетов.Добавить(Макет.Имя);
	КонецЦикла;
	
	ХешСуммыРасширений = ПолучитьТаблицуХешСуммДанныхРасширений();
	
	//Создадим/обновим расширения
	Для каждого ИмяМакета Из ИменаМакетов Цикл
		ДвоичныеДанные = ПолучитьМакет(ИмяМакета);
		
		ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.SHA1);
		ХешированиеДанных.Добавить(ДвоичныеДанные);
		ХешСумма = Base64Строка(ХешированиеДанных.ХешСумма);
		
		Отбор = Новый Структура("Имя", ИмяМакета);
		
		Найденное = РасширенияКонфигурации.Получить(Отбор);
		
		НовоеРасширение = Ложь;
		Если Найденное.Количество() Тогда
			Расширение = Найденное[0];
		Иначе
			Расширение = РасширенияКонфигурации.Создать();
			НовоеРасширение = Истина;
		КонецЕсли;
		
		Если НовоеРасширение ИЛИ ХешСумма <> ХешСуммаПоТаблицеХешСумм(ХешСуммыРасширений, Расширение.Имя) Тогда
			Расширение.БезопасныйРежим = Ложь;
			Расширение.Записать(ДвоичныеДанные);
			Запись = РегистрыСведений.грРасширенияКонфигурации.СоздатьМенеджерЗаписи();
			Запись.ИмяРасширения = Расширение.Имя;
			Запись.ХешСумма = ХешСумма;
			Запись.Записать();
		КонецЕсли;
		
	КонецЦикла;
	
	//Удалим невалидные расширения и записи регистра
	ВсеРасширения = РасширенияКонфигурации.Получить();
	ИменаРасширений = Новый Массив;
	Для каждого Расширение Из ВсеРасширения Цикл
		Если ИменаМакетов.Найти(Расширение.Имя) = Неопределено Тогда
			Расширение.Удалить();
		КонецЕсли;
		ИменаРасширений.Добавить(Расширение.Имя);
	КонецЦикла;
	
	Для каждого Строка Из ХешСуммыРасширений Цикл
		Если ИменаРасширений.Найти(Строка.ИмяРасширения) = Неопределено Тогда
			Запись = РегистрыСведений.грРасширенияКонфигурации.СоздатьМенеджерЗаписи();
			Запись.ИмяРасширения = Строка.ИмяРасширения;
			Запись.Удалить();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьТаблицуХешСуммДанныхРасширений()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	грРасширенияКонфигурации.ИмяРасширения КАК ИмяРасширения,
		|	грРасширенияКонфигурации.ХешСумма КАК ХешСумма
		|ИЗ
		|	РегистрСведений.грРасширенияКонфигурации КАК грРасширенияКонфигурации";
	
	Возврат Запрос.Выполнить().Выгрузить();

КонецФункции // ()

Функция ХешСуммаПоТаблицеХешСумм(ХешСуммы, ИмяРасширения)
	
	Данные = ХешСуммы.Найти(ИмяРасширения, "ИмяРасширения");
	
	Если Данные <> Неопределено Тогда
		Возврат Данные.ХешСумма;
	КонецЕсли;

КонецФункции // ()
//--- Градум; Курпяев Е.Д. ; 22.03.2018; Трек UH0001_Подготовка конфигурации


