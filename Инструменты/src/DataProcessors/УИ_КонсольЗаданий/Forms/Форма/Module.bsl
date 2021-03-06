#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ОтборПриОткрытии()

	ЭтаФорма.ОтборФоновыхЗаданийВключен = Истина;
	// защитный фильтр при интенсивном запуске фоновых
	ЭтаФорма.ОтборФоновыхЗаданий = Новый ХранилищеЗначения(Новый Структура("Начало", ТекущаяДата() - 3600));

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Попытка
		ОтборПриОткрытии();
		Если АвтообновлениеСпискаФоновыхЗаданий = Истина Тогда
			ПодключитьОбработчикОжидания("ОбработчикАвтообновленияФоновыхЗаданий",
				ПериодАвтообновленияСпискаФоновыхЗаданий);
		КонецЕсли;

		Если АвтообновлениеСпискаРегламентныхЗаданий = Истина Тогда
			ПодключитьОбработчикОжидания("ОбработчикАвтообновленияРегламентныхЗаданий",
				ПериодАвтообновленияСпискаРегламентныхЗаданий);
		КонецЕсли;

		ОбновитьСписокФоновыхЗаданий();
		ОбновитьСписокРегламентныхЗаданий();
	Исключение
		ПоказатьИнформациюОбОшибке(ИнформацияОбОшибке());
	КонецПопытки;

#Если ТолстыйКлиентОбычноеПриложение Тогда
	Элементы.СписокРегламентныхЗаданийЖурналРегистрации1.Видимость = Ложь;
#КонецЕсли
#Если ТолстыйКлиентОбычноеПриложение Или ТолстыйКлиентУправляемоеПриложение Тогда
	Элементы.СписокРегламентныхЗаданийВыполнитьЗаданиеВручную.Заголовок = "На клиенте";
#КонецЕсли
	Элементы.СписокФоновыхЗаданийНастройкаСпискаФоновыхЗаданий.Пометка = АвтообновлениеСпискаФоновыхЗаданий;
	Элементы.СписокРегламентныхЗаданийНастройкаСпискаРегламентныхЗаданий.Пометка = АвтообновлениеСпискаРегламентныхЗаданий;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	ОтключитьОбработчикОжидания("ОбработчикАвтообновленияФоновыхЗаданий");
	ОтключитьОбработчикОжидания("ОбработчикАвтообновленияРегламентныхЗаданий");
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикАвтообновленияФоновыхЗаданий()
	//Попытка
	ОбновитьСписокФоновыхЗаданий();
	//Исключение
	//	// Может возикать ошибка "Неизвестный идентификатор формы"
	//КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикАвтообновленияРегламентныхЗаданий()
	//Попытка 
	ОбновитьСписокРегламентныхЗаданий();
	//Исключение
	//	// Может возикать ошибка "Неизвестный идентификатор формы"
	//КонецПопытки;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
// Код процедур и функций
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокРегламентныхЗаданий

&НаКлиенте
Процедура СписокРегламентныхЗаданийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ИдентификаторЗадания", "");

	ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("СписокРегламентныхЗаданийПередНачаломДобавленияЗавершение",
		ЭтаФорма);

	ОткрытьФорму(ПолучитьПолноеИмяФормы("ДиалогРегламентногоЗадания"), СтруктураПараметров, ЭтаФорма, , , ,
		ОписаниеОповещенияОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура СписокРегламентныхЗаданийПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	Если РезультатЗакрытия <> Неопределено Тогда
		ОбновитьСписокРегламентныхЗаданий();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокРегламентныхЗаданийПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
	ВыделенныеСтроки = Элементы.СписокРегламентныхЗаданий.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() > 0 Тогда

		Строка = СписокРегламентныхЗаданий.НайтиПоИдентификатору(ВыделенныеСтроки.Получить(0));

		СтруктураПараметров = Новый Структура;
		Ид = Строка.Идентификатор;
		СтруктураПараметров.Вставить("ИдентификаторЗадания", Ид);

		ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("СписокРегламентныхЗаданийПередНачаломИзмененияЗавершение",
			ЭтаФорма);

		ОткрытьФорму(ПолучитьПолноеИмяФормы("ДиалогРегламентногоЗадания"), СтруктураПараметров, ЭтаФорма, , , ,
			ОписаниеОповещенияОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокРегламентныхЗаданийПередНачаломИзмененияЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	Если РезультатЗакрытия <> Неопределено Тогда
		ОбновитьСписокРегламентныхЗаданий();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокРегламентныхЗаданийПередУдалением(Элемент, Отказ)
	Попытка
		Отказ = Истина;
		УдалитьРегламентноеЗадание();

		ОбновитьСписокРегламентныхЗаданий();
	Исключение
		ПоказатьИнформациюОбОшибке(ИнформацияОбОшибке());
	КонецПопытки;
КонецПроцедуры

&НаСервере
Процедура УдалитьРегламентноеЗадание()
	ВыделенныеСтроки = Элементы.СписокРегламентныхЗаданий.ВыделенныеСтроки;
	Для Каждого Стр Из ВыделенныеСтроки Цикл
		Строка = СписокРегламентныхЗаданий.НайтиПоИдентификатору(Стр);

		РегламентноеЗадание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Строка.Идентификатор);
		Если РегламентноеЗадание.Предопределенное Тогда
			ВызватьИсключение ("Нельзя удалить предопределенное задание: " + РегламентноеЗадание.Наименование);
		КонецЕсли;
	КонецЦикла;

	Для Каждого Стр Из ВыделенныеСтроки Цикл
		Строка = СписокРегламентныхЗаданий.НайтиПоИдентификатору(Стр);
		РегламентноеЗадание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Строка.Идентификатор);
		РегламентноеЗадание.Удалить();
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СписокРегламентныхЗаданийПриАктивизацииСтроки(Элемент)
	ТекущаяСтрока = Элементы.СписокРегламентныхЗаданий.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ТекущиеДанные = ЭтаФорма.СписокРегламентныхЗаданий.НайтиПоИдентификатору(ТекущаяСтрока);
	Если ТекущиеДанные <> Неопределено Тогда
		СвойстваПоследнегоВыполненого = ПолучитьСвойстваПоследнегоВыполненого(ТекущиеДанные.Идентификатор);
		ТекущиеДанные.Состояние = СвойстваПоследнегоВыполненого.Состояние;
		ТекущиеДанные.Выполнялось = СвойстваПоследнегоВыполненого.Выполнялось;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
// Код процедур и функций
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПолучитьПолноеИмяФормы(ИмяФормы)
	Возврат Лев(ЭтаФорма.ИмяФормы, Найти(ЭтаФорма.ИмяФормы, ".Форма.") + 6) + ИмяФормы;
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьСвойстваПоследнегоВыполненого(ИдентификаторРегламентногоЗадания, Регламентное_ = Неопределено)
	Результат = Новый Структура("Выполнялось, Состояние");
	Если Регламентное_ = Неопределено Тогда
		Регламентное = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторРегламентногоЗадания);
	Иначе
		Регламентное = Регламентное_;
	КонецЕсли;
	Если Регламентное <> Неопределено Тогда
		Попытка
			// вызывает тормоза, если регламентное выполнялось давно и фоновых было много
			ПоследнееЗадание = Регламентное.ПоследнееЗадание;
		Исключение
			ПоследнееЗадание = Неопределено;
			Инфо = ИнформацияОбОшибке();
			Сообщить(ПодробноеПредставлениеОшибки(Инфо));
			Возврат Результат;
		КонецПопытки;

		Если ПоследнееЗадание <> Неопределено Тогда
			Результат.Выполнялось = Строка(ПоследнееЗадание.Начало);
			Результат.Состояние = Строка(ПоследнееЗадание.Состояние);
		КонецЕсли;

	КонецЕсли;
	Возврат Результат;
КонецФункции

#КонецОбласти

#Область ОбработчикиКомандТаблицыСписокРегламентныхЗаданий

&НаКлиенте
Процедура УстановитьОтборРегламентныхЗаданий(Команда)
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Отбор", ОтборРегламентныхЗаданий);

	ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("УстановитьОтборРегламентныхЗаданийЗавершение", ЭтаФорма);

	ОткрытьФорму(ПолучитьПолноеИмяФормы("ДиалогОтбораРегламентногоЗадания"), СтруктураПараметров, ЭтаФорма, , , ,
		ОписаниеОповещенияОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборРегламентныхЗаданийЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(РезультатЗакрытия) = Тип("Структура") Тогда
		ОтборРегламентныхЗаданий = РезультатЗакрытия;
		ОтборРегламентныхЗаданийВключен = Истина;
		ОбновитьСписокРегламентныхЗаданий();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьОтборРегламентныхЗаданий(Команда)
	ОтборРегламентныхЗаданийВключен = Ложь;
	ОбновитьСписокРегламентныхЗаданий();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьРегламентныеЗадания(Команда)
	ОбновитьСписокРегламентныхЗаданий();
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокРегламентныхЗаданий()
	Перем ТекущийИдентификатор;

	ТекущаяСтрока = Элементы.СписокРегламентныхЗаданий.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		ТекСтрока = СписокРегламентныхЗаданий.НайтиПоИдентификатору(ТекущаяСтрока);
		ТекущийИдентификатор = ТекСтрока.Идентификатор;
	КонецЕсли;

	Идентификаторы = Новый Массив;

	ВыделенныеСтроки = Элементы.СписокРегламентныхЗаданий.ВыделенныеСтроки;
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		ТекСтрока = СписокРегламентныхЗаданий.НайтиПоИдентификатору(ВыделеннаяСтрока);
		Идентификаторы.Добавить(ТекСтрока.Идентификатор);
	КонецЦикла;

	СписокРегламентныхЗаданий.Очистить();

	Отбор = Неопределено;
	СтрокаОтбора = "";
	Если ОтборРегламентныхЗаданийВключен = Истина Тогда
		Отбор = ОтборРегламентныхЗаданий;
		Для Каждого Элемент Из Отбор Цикл
			Если СтрокаОтбора <> "" Тогда
				СтрокаОтбора = СтрокаОтбора + ";";
			КонецЕсли
			;
			СтрокаОтбора = СтрокаОтбора + Элемент.Ключ + ": " + Элемент.Значение;
		КонецЦикла;
		Если СтрокаОтбора <> "" Тогда
			СтрокаОтбора = " (" + СтрокаОтбора + ")";
		КонецЕсли;
	КонецЕсли;
	Элементы.РегламентныеЗадания.Заголовок = "Регламентные задания" + СтрокаОтбора;

	Попытка
		Регламентные = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Отбор);
	Исключение
		//Элементы.СписокРегламентныхЗаданий.Доступность = Ложь;
		Инфо = ИнформацияОбОшибке();
		Сообщить(ПодробноеПредставлениеОшибки(Инфо));
		Возврат;
	КонецПопытки;
	
	//Элементы.СписокРегламентныхЗаданий.Доступность = Истина;
	НачалоЗамера = ТекущаяУниверсальнаяДатаВМиллисекундах();
	Оптимизация = Ложь;

	Для Каждого Регламентное Из Регламентные Цикл
		НоваяСтрока = СписокРегламентныхЗаданий.Добавить();
		НоваяСтрока.Метаданные = Регламентное.Метаданные.Представление();
		НоваяСтрока.Наименование = Регламентное.Наименование;
		НоваяСтрока.Ключ = Регламентное.Ключ;
		НоваяСтрока.Расписание = Регламентное.Расписание;
		НоваяСтрока.Пользователь = Регламентное.ИмяПользователя;
		НоваяСтрока.Предопределенное = Регламентное.Предопределенное;
		НоваяСтрока.Использование = Регламентное.Использование;
		НоваяСтрока.Идентификатор = Регламентное.УникальныйИдентификатор;
		НоваяСтрока.Метод = Регламентное.Метаданные.ИмяМетода;

		Если ТекущаяУниверсальнаяДатаВМиллисекундах() - НачалоЗамера < 1000 Тогда
			// На больших базах подвисает...
			СвойстваПоследнегоВыполненого = ПолучитьСвойстваПоследнегоВыполненого(НоваяСтрока.Идентификатор,
				Регламентное);
			НоваяСтрока.Состояние = СвойстваПоследнегоВыполненого.Состояние;
			НоваяСтрока.Выполнялось = СвойстваПоследнегоВыполненого.Выполнялось;
		Иначе
			Оптимизация = Истина;
		КонецЕсли;

		ИмяРегламентногоЗадания = НоваяСтрока.Метаданные + ?(ЗначениеЗаполнено(НоваяСтрока.Наименование), ":"
			+ НоваяСтрока.Наименование, "");
		Строки = СписокФоновыхЗаданий.НайтиСтроки(Новый Структура("Метод, Наименование", НоваяСтрока.Метод,
			НоваяСтрока.Наименование));
		Для Каждого Фоновое Из Строки Цикл
			Фоновое.Регламентное = ИмяРегламентногоЗадания;
		КонецЦикла;
	КонецЦикла;

	Если Оптимизация Тогда
		Пояснение = "Получение состояния всех рег. заданий заняло длительное время, поэтому обновление происходит только при активации строки.";
		Элементы.СписокРегламентныхЗаданийВыполнялось.Заголовок = "Выполнялось*";
		Элементы.СписокРегламентныхЗаданийВыполнялось.Подсказка = Пояснение;
		Элементы.СписокРегламентныхЗаданийСостояние.Заголовок = "Состояние*";
		Элементы.СписокРегламентныхЗаданийСостояние.Подсказка = Пояснение;
	КонецЕсли;

	СписокРегламентныхЗаданий.Сортировать("Метаданные");

	Если ТекущийИдентификатор <> Неопределено Тогда
		Строки = СписокРегламентныхЗаданий.НайтиСтроки(Новый Структура("Идентификатор", ТекущийИдентификатор));
		Если Строки.Количество() > 0 Тогда
			Элементы.СписокРегламентныхЗаданий.ТекущаяСтрока = Строки[0].ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;

	Если Идентификаторы.Количество() > 0 Тогда
		ВыделенныеСтроки.Очистить();
	КонецЕсли;

	Для Каждого Идентификатор Из Идентификаторы Цикл
		Строки = СписокРегламентныхЗаданий.НайтиСтроки(Новый Структура("Идентификатор", Идентификатор));
		Если Строки.Количество() > 0 Тогда
			ВыделенныеСтроки.Добавить(Строки[0].ПолучитьИдентификатор());
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура Расписание(Команда)
	ВыделенныеСтроки = Элементы.СписокРегламентныхЗаданий.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() > 0 Тогда

		Строка = СписокРегламентныхЗаданий.НайтиПоИдентификатору(ВыделенныеСтроки.Получить(0));
		Расписание = ПолучитьРасписаниеРегламентногоЗадания(Строка.Идентификатор);
		Диалог = Новый ДиалогРасписанияРегламентногоЗадания(Расписание);
		ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("ДиалогРасписанияРегламентногоЗаданияОткрытьЗавершение",
			ЭтаФорма);

		Диалог.Показать(ОписаниеОповещенияОЗакрытии);

	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьРасписаниеРегламентногоЗадания(УникальныйНомерЗадания)
	ОбъектЗадания = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(УникальныйНомерЗадания);
	Если ОбъектЗадания = Неопределено Тогда
		Возврат Новый РасписаниеРегламентногоЗадания;
	КонецЕсли;

	Возврат ОбъектЗадания.Расписание;
КонецФункции

&НаКлиенте
Процедура ДиалогРасписанияРегламентногоЗаданияОткрытьЗавершение(Расписание, ДополнительныеПараметры) Экспорт
	Если Расписание <> Неопределено Тогда
		ВыделенныеСтроки = Элементы.СписокРегламентныхЗаданий.ВыделенныеСтроки;
		Если ВыделенныеСтроки.Количество() > 0 Тогда
			Строка = СписокРегламентныхЗаданий.НайтиПоИдентификатору(ВыделенныеСтроки.Получить(0));
			УстановитьРасписаниеРегламентногоЗадания(Строка.Идентификатор, Строка.Наименование, Расписание,
				Строка.Метаданные);
			Строка.Расписание = Расписание;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция УстановитьРасписаниеРегламентногоЗадания(Идентификатор, Наименование, Расписание, ИмяЗадания)
	ОбъектЗадания = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Идентификатор);
	Если ОбъектЗадания = Неопределено Тогда
		РедОбъектЗадания = РегламентныеЗадания.СоздатьРегламентноеЗадание(ИмяЗадания);
		РедОбъектЗадания.Наименование = Наименование;
		РедОбъектЗадания.Использование = Истина;
	Иначе
		РедОбъектЗадания = ОбъектЗадания;
	КонецЕсли;

	РедОбъектЗадания.Расписание = Расписание;
	Попытка
		РедОбъектЗадания.Записать();
	Исключение
		ВызватьИсключение "Произошла ошибка при сохранении расписания выполнения обменов. Возможно данные расписания были изменены. Закройте форму настройки и повторите попытку изменения расписания еще раз.
						  |Подробное описание ошибки: " + ОписаниеОшибки();
	КонецПопытки;

	Возврат Истина;
КонецФункции

&НаКлиенте
Процедура НастройкаСпискаРегламентныхЗаданий(Команда)
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Автообновление", АвтообновлениеСпискаРегламентныхЗаданий);
	СтруктураПараметров.Вставить("ПериодАвтообновления", ПериодАвтообновленияСпискаРегламентныхЗаданий);

	ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("НастройкаСпискаРегламентныхЗаданийЗавершение", ЭтаФорма);

	ОткрытьФорму(ПолучитьПолноеИмяФормы("ДиалогНастроекСписка"), СтруктураПараметров, ЭтаФорма, , , ,
		ОписаниеОповещенияОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура НастройкаСпискаРегламентныхЗаданийЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(РезультатЗакрытия) = Тип("Структура") Тогда
		АвтообновлениеСпискаРегламентныхЗаданий = РезультатЗакрытия.Автообновление;
		ПериодАвтообновленияСпискаРегламентныхЗаданий = РезультатЗакрытия.ПериодАвтообновления;

		ОтключитьОбработчикОжидания("ОбработчикАвтообновленияРегламентныхЗаданий");
		Если АвтообновлениеСпискаРегламентныхЗаданий = Истина Тогда
			ПодключитьОбработчикОжидания("ОбработчикАвтообновленияРегламентныхЗаданий",
				ПериодАвтообновленияСпискаРегламентныхЗаданий);
		КонецЕсли;
		Элементы.СписокРегламентныхЗаданийНастройкаСпискаРегламентныхЗаданий.Пометка = АвтообновлениеСпискаРегламентныхЗаданий;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗаданиеВручную(Команда)
	ТекущаяСтрока = Элементы.СписокРегламентныхЗаданий.ТекущиеДанные;
	Если ТекущаяСтрока <> Неопределено Тогда
		ВыполнитьЗаданиеВручнуюНаСервере(ТекущаяСтрока.Идентификатор);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЗаданиеВручнуюНаСервере(УникальныйИдентификатор)
	Идентификатор = Новый УникальныйИдентификатор(УникальныйИдентификатор);
	Задание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Идентификатор);

	ИмяМетода = Задание.Метаданные.ИмяМетода;
		
	// Подготовка команды для выполнения метода вместо фонового задания.
	СтрокаПараметров = "";
	Индекс = 0;
	Пока Индекс < Задание.Параметры.Количество() Цикл
		СтрокаПараметров = СтрокаПараметров + "Задание.Параметры[" + Индекс + "]";
		Если Индекс < (Задание.Параметры.Количество() - 1) Тогда
			СтрокаПараметров = СтрокаПараметров + ",";
		КонецЕсли;
		Индекс = Индекс + 1;
	КонецЦикла;

	Выполнить ("" + ИмяМетода + "(" + СтрокаПараметров + ");");

КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьЗадание(Команда)
	ТекущаяСтрока = Элементы.СписокРегламентныхЗаданий.ТекущиеДанные;
	Если ТекущаяСтрока <> Неопределено Тогда
		ЗапуститьЗаданиеНаСервере(ТекущаяСтрока.Идентификатор);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗапуститьЗаданиеНаСервере(УникальныйИдентификатор)

	Идентификатор = Новый УникальныйИдентификатор(УникальныйИдентификатор);
	Задание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Идентификатор);
	//Если Задание.Использование Тогда
		
		//проверка на выполнение в текущий момент
	Отбор=Новый Структура;
	Отбор.Вставить("Ключ", Строка(Задание.УникальныйИдентификатор));
	Отбор.Вставить("Состояние ", СостояниеФоновогоЗадания.Активно);
	МассивЗаданий=ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);

	ИдентификаторНовогоЗадания = Неопределено;

	Если МассивЗаданий.Количество() = 0 Тогда
		НаименованиеФоновогоЗадания = "Запуск вручную: " + Задание.Метаданные.Синоним;
		ФоновоеЗадание = ФоновыеЗадания.Выполнить(Задание.Метаданные.ИмяМетода, Задание.Параметры, Строка(
			Задание.УникальныйИдентификатор), НаименованиеФоновогоЗадания);
		ИдентификаторНовогоЗадания = ФоновоеЗадание.УникальныйИдентификатор;
	Иначе
		Сообщить("Задание уже запущено");
	КонецЕсли;
		
	//КонецЕсли;
	ОбновитьСписокРегламентныхЗаданий();
	ОбновитьСписокФоновыхЗаданий(ИдентификаторНовогоЗадания);
КонецПроцедуры

&НаКлиенте
Процедура ЖурналРегистрации(Команда)
	ИмяФормыЖР = "ВнешняяОбработка.StandardEventLog.Форма";
	ПодключитьВнешнююОбработкуНаСервере();
	ОткрытьФорму(ИмяФормыЖР);
КонецПроцедуры

&НаСервере
Процедура ПодключитьВнешнююОбработкуНаСервере()
	ВнешниеОбработки.Подключить("v8res://mngbase/StandardEventLog.epf", "StandardEventLog", False);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокФоновыхЗаданий

&НаКлиенте
Процедура СписокФоновыхЗаданийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;

	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ИдентификаторЗадания", "");
	Если Копирование Тогда
		ТекущиеДанные = Элементы.СписокФоновыхЗаданий.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			СтруктураПараметров.Вставить("ИмяМетода", ТекущиеДанные.Метод);
			СтруктураПараметров.Вставить("Наименование", ТекущиеДанные.Наименование);
			СтруктураПараметров.Вставить("Ключ", ТекущиеДанные.Ключ);
		КонецЕсли;
	КонецЕсли;

	ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("СписокФоновыхЗаданийПередНачаломДобавленияЗавершение",
		ЭтаФорма);

	ОткрытьФорму(ПолучитьПолноеИмяФормы("ДиалогФоновогоЗадания"), СтруктураПараметров, ЭтаФорма, , , ,
		ОписаниеОповещенияОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура СписокФоновыхЗаданийПередНачаломДобавленияЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	Если РезультатЗакрытия <> Неопределено Тогда
		ОбновитьСписокФоновыхЗаданий();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокФоновыхЗаданийПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СписокФоновыхЗаданийПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СписокФоновыхЗаданийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Поле.Имя = "СписокФоновыхЗаданийСообщения" Тогда
		СписокФоновыхЗаданийСообщенияВыборНаСервере(ВыбраннаяСтрока);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СписокФоновыхЗаданийСообщенияВыборНаСервере(ИдентификаторСтроки)
	ТекущаяСтрока = СписокФоновыхЗаданий.НайтиПоИдентификатору(ИдентификаторСтроки);
	Фоновое = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ТекущаяСтрока.Идентификатор);
	Если Фоновое <> Неопределено Тогда
		СообщенияПользователю = Фоновое.ПолучитьСообщенияПользователю();
		Для Каждого Сообщение Из СообщенияПользователю Цикл
			;
			Сообщить(Сообщение.Текст);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандТаблицыСписокФоновыхЗаданий

&НаКлиенте
Процедура ОтменитьФоновоеЗадание(Команда)
	Попытка
		ОтменитьФоновыеЗадания();
		ОбновитьСписокФоновыхЗаданий();
	Исключение
		ПоказатьИнформациюОбОшибке(ИнформацияОбОшибке());
	КонецПопытки;
КонецПроцедуры

&НаСервере
Процедура ОтменитьФоновыеЗадания()
	ВыделенныеСтроки = Элементы.СписокФоновыхЗаданий.ВыделенныеСтроки;
	Для Каждого Стр Из ВыделенныеСтроки Цикл
		Строка = СписокФоновыхЗаданий.НайтиПоИдентификатору(Стр);
		ТекИдентификатор = Новый УникальныйИдентификатор(Строка.Идентификатор);
		ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ТекИдентификатор);
		ФоновоеЗадание.Отменить();
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборФоновыхЗаданий(Команда)
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Отбор", ОтборФоновыхЗаданий);

	ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("УстановитьОтборФоновыхЗаданийЗавершение", ЭтаФорма);

	ОткрытьФорму(ПолучитьПолноеИмяФормы("ДиалогОтбораФоновогоЗадания"), СтруктураПараметров, ЭтаФорма, , , ,
		ОписаниеОповещенияОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборФоновыхЗаданийЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(РезультатЗакрытия) = Тип("ХранилищеЗначения") Тогда
		ОтборФоновыхЗаданий = РезультатЗакрытия;
		ОтборФоновыхЗаданийВключен = Истина;
		ОбновитьСписокФоновыхЗаданий();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоТекущему(Команда)
	ТекИдентификаторСтроки = Элементы.СписокРегламентныхЗаданий.ТекущаяСтрока;
	Если ТекИдентификаторСтроки <> Неопределено Тогда
		ОтборПоТекущемуНаСервере(ТекИдентификаторСтроки);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОтборПоТекущемуНаСервере(ТекИдентификаторСтроки)
	ТекЗадание = СписокРегламентныхЗаданий.НайтиПоИдентификатору(ТекИдентификаторСтроки);

	ТекОтбор = Новый Структура;
	//Если ТипЗнч(ОтборФоновыхЗаданий) = Тип("ХранилищеЗначения") Тогда
	//	ТекОтбор = ОтборФоновыхЗаданий.Получить();
	//КонецЕсли;

	Регламентное = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(ТекЗадание.Идентификатор);
	ТекОтбор.Вставить("РегламентноеЗадание", Регламентное);

	ОтборФоновыхЗаданий = Новый ХранилищеЗначения(ТекОтбор);
	ОтборФоновыхЗаданийВключен = Истина;
	ОбновитьСписокФоновыхЗаданий();

КонецПроцедуры

&НаКлиенте
Процедура ОтключитьОтборФоновыхЗаданий(Команда)
	ОтборФоновыхЗаданийВключен = Ложь;
	ОбновитьСписокФоновыхЗаданий();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьФоновыеЗадания(Команда)
	ОбновитьСписокФоновыхЗаданий();
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокФоновыхЗаданий(ИдентификаторНовогоЗадания = Неопределено)
	Перем ТекущийИдентификатор;

	ТекущаяСтрока = Элементы.СписокФоновыхЗаданий.ТекущаяСтрока;
	Если ТекущаяСтрока <> Неопределено Тогда
		ТекСтрока = СписокФоновыхЗаданий.НайтиПоИдентификатору(ТекущаяСтрока);
		ТекущийИдентификатор = ТекСтрока.Идентификатор;
	КонецЕсли;

	Если ЗначениеЗаполнено(ИдентификаторНовогоЗадания) Тогда
		ТекущийИдентификатор = ИдентификаторНовогоЗадания;
	КонецЕсли;

	Идентификаторы = Новый Массив;

	ВыделенныеСтроки = Элементы.СписокФоновыхЗаданий.ВыделенныеСтроки;
	Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
		ТекСтрока = СписокФоновыхЗаданий.НайтиПоИдентификатору(ВыделеннаяСтрока);
		Идентификаторы.Добавить(ТекСтрока.Идентификатор);
	КонецЦикла;

	СписокФоновыхЗаданий.Очистить();

	Отбор = Неопределено;
	СтрокаОтбора = "";
	Если ОтборФоновыхЗаданийВключен = Истина Тогда
		Отбор = ОтборФоновыхЗаданий.Получить();
		Для Каждого Элемент Из Отбор Цикл
			Если СтрокаОтбора <> "" Тогда
				СтрокаОтбора = СтрокаОтбора + ";";
			КонецЕсли
			;
			СтрокаОтбора = СтрокаОтбора + Элемент.Ключ + ": " + Элемент.Значение;
		КонецЦикла;
		Если СтрокаОтбора <> "" Тогда
			СтрокаОтбора = " (" + СтрокаОтбора + ")";
		КонецЕсли;
	КонецЕсли;
	Элементы.ФоновыеЗадания.Заголовок = "Фоновые задания" + СтрокаОтбора;

	Попытка
		Фоновые = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
	Исключение
		Инфо = ИнформацияОбОшибке();
		Сообщить(ПодробноеПредставлениеОшибки(Инфо));
		//Элементы.СписокФоновыхЗаданий.Доступность = Ложь;
		Возврат;
	КонецПопытки;
	
	//Элементы.СписокФоновыхЗаданий.Доступность = Истина;
	Для Каждого Фоновое Из Фоновые Цикл
		НоваяСтрока = СписокФоновыхЗаданий.Добавить();

		НоваяСтрока.Сообщения = Фоновое.ПолучитьСообщенияПользователю().Количество();
		Строки = СписокРегламентныхЗаданий.НайтиСтроки(Новый Структура("Метод, Наименование", Фоновое.ИмяМетода,
			Фоновое.Наименование));
		Если Строки.Количество() > 0 Тогда
			Если СписокФоновыхЗаданий.Индекс(НоваяСтрока) = 0 Тогда
				Строки[0].Выполнялось = Фоновое.Начало;
				Строки[0].Состояние = Фоновое.Состояние;
			КонецЕсли;
			ИмяРегламентногоЗадания = Строки[0].Метаданные + ":" + Строки[0].Наименование;
			НоваяСтрока.Регламентное = ИмяРегламентногоЗадания;
		Иначе
			НоваяСтрока.Регламентное = Фоновое.УникальныйИдентификатор;
		КонецЕсли;

		НоваяСтрока.Наименование = Фоновое.Наименование;
		НоваяСтрока.Ключ = Фоновое.Ключ;
		НоваяСтрока.Метод = Фоновое.ИмяМетода;
		НоваяСтрока.Состояние = Фоновое.Состояние;
		НоваяСтрока.Начало = Фоновое.Начало;
		НоваяСтрока.Конец = Фоновое.Конец;
		НоваяСтрока.Сервер = Фоновое.Расположение;

		Если Фоновое.ИнформацияОбОшибке <> Неопределено Тогда
			НоваяСтрока.Ошибки = Фоновое.ИнформацияОбОшибке.Описание;
		КонецЕсли;

		НоваяСтрока.Идентификатор = Фоновое.УникальныйИдентификатор;
		НоваяСтрока.СостояниеЗадания = Фоновое.Состояние;
	КонецЦикла;

	Если ТекущийИдентификатор <> Неопределено Тогда
		Строки = СписокФоновыхЗаданий.НайтиСтроки(Новый Структура("Идентификатор", ТекущийИдентификатор));
		Если Строки.Количество() > 0 Тогда
			Элементы.СписокФоновыхЗаданий.ТекущаяСтрока = Строки[0].ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;

	Если Идентификаторы.Количество() > 0 Тогда
		ВыделенныеСтроки.Очистить();
	КонецЕсли;

	Для Каждого Идентификатор Из Идентификаторы Цикл
		Строки = СписокФоновыхЗаданий.НайтиСтроки(Новый Структура("Идентификатор", Идентификатор));
		Если Строки.Количество() > 0 Тогда
			ВыделенныеСтроки.Добавить(Строки[0].ПолучитьИдентификатор());
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура НастройкаСпискаФоновыхЗаданий(Команда)

	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Автообновление", АвтообновлениеСпискаФоновыхЗаданий);
	СтруктураПараметров.Вставить("ПериодАвтообновления", ПериодАвтообновленияСпискаФоновыхЗаданий);

	ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("НастройкаСпискаФоновыхЗаданийЗавершение", ЭтаФорма);

	ОткрытьФорму(ПолучитьПолноеИмяФормы("ДиалогНастроекСписка"), СтруктураПараметров, ЭтаФорма, , , ,
		ОписаниеОповещенияОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура НастройкаСпискаФоновыхЗаданийЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(РезультатЗакрытия) = Тип("Структура") Тогда
		АвтообновлениеСпискаФоновыхЗаданий = РезультатЗакрытия.Автообновление;
		ПериодАвтообновленияСпискаФоновыхЗаданий = РезультатЗакрытия.ПериодАвтообновления;

		ОтключитьОбработчикОжидания("ОбработчикАвтообновленияФоновыхЗаданий");
		Если АвтообновлениеСпискаФоновыхЗаданий = Истина Тогда
			ПодключитьОбработчикОжидания("ОбработчикАвтообновленияФоновыхЗаданий",
				ПериодАвтообновленияСпискаФоновыхЗаданий);
		КонецЕсли;

		Элементы.СписокФоновыхЗаданийНастройкаСпискаФоновыхЗаданий.Пометка = АвтообновлениеСпискаФоновыхЗаданий;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти