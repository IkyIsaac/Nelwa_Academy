import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/auth/firebase_auth/auth_util.dart';

List<DateTime>? dateFromMessages(List<SupportMessageRecord>? messageDoc) {
  if (messageDoc == null || messageDoc.isEmpty) {
    return null;
  }

  // Создаем Set для хранения уникальных дат
  final uniqueDates = <DateTime>{};

  for (final message in messageDoc) {
    final timestamp = message.timeStamp;
    if (timestamp != null) {
      // Приводим время к началу дня, чтобы сравнивать только даты
      final dateOnly = DateTime(timestamp.year, timestamp.month, timestamp.day);
      uniqueDates.add(dateOnly);
    }
  }

  // Преобразуем Set обратно в List и сортируем по возрастанию
  final sortedDates = uniqueDates.toList()..sort();

  return sortedDates;
}

List<SupportMessageRecord> similarDates(
  DateTime selectedDate,
  List<SupportMessageRecord> messagesDoc,
) {
  if (messagesDoc.isEmpty) {
    return [];
  }

  // Приводим selectedDate к началу дня для сравнения только дат
  final selectedDateOnly =
      DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

  // Фильтруем документы, у которых дата time_stamp совпадает с selectedDate
  final filteredMessages = messagesDoc.where((message) {
    final messageTimestamp = message.timeStamp;
    if (messageTimestamp == null) {
      return false;
    }
    // Приводим time_stamp к началу дня для сравнения
    final messageDateOnly = DateTime(
        messageTimestamp.year, messageTimestamp.month, messageTimestamp.day);
    return messageDateOnly == selectedDateOnly;
  }).toList();

  return filteredMessages;
}

String totalDuration(int courseMinutes) {
  if (courseMinutes <= 0) return "0 minutes";

  int hours = courseMinutes ~/ 60;
  int minutes = courseMinutes % 60;

  if (hours > 0 && minutes > 0) {
    return "$hours ${hours == 1 ? 'hour' : 'hours'} and $minutes ${minutes == 1 ? 'minute' : 'minutes'}";
  } else if (hours > 0) {
    return "$hours ${hours == 1 ? 'hour' : 'hours'}";
  } else {
    return "$minutes ${minutes == 1 ? 'minute' : 'minutes'}";
  }
}

String first120Symbols(String text) {
  // Проверяем, если длина текста меньше или равна 120, возвращаем его полностью
  if (text.length <= 120) {
    return text;
  }

  // Если длина текста больше 120, возвращаем первые 120 символов
  return text.substring(0, 120);
}

String lessonDuration(int seconds) {
  if (seconds <= 0) return "00:00:00";

  int hours = seconds ~/ 3600;
  int minutes = (seconds % 3600) ~/ 60;
  int secs = seconds % 60;

  String hoursStr = hours > 0 ? "$hours:" : "";
  String minutesStr = minutes < 10 ? "0$minutes" : "$minutes";
  String secondsStr = secs < 10 ? "0$secs" : "$secs";

  return "$hoursStr$minutesStr:$secondsStr";
}

bool more120Characters(String text) {
  return text.length > 120;
}

List<String> hoursList() {
  // Give me the watch sheet. And so that they are two-digit
  List<String> hours = [];
  for (int i = 0; i < 24; i++) {
    hours.add(i.toString().padLeft(2, '0'));
  }
  return hours;
}

List<String> minutesList() {
  // Give me a few minutes. And so that they are two-digit
  List<String> minutes = [];
  for (int i = 0; i < 60; i++) {
    minutes.add(i.toString().padLeft(2, '0'));
  }
  return minutes;
}

String? hiddenText(
  String? contentText,
  int? frontText,
  int? backText,
) {
  // frontText is the number of characters from the beginning of the text backText is the number of characters from the end of the text. Make sure that as many characters are shown in the front as indicated in the fronText and as many characters are shown in the back as indicated in the backText, put * in place of the remaining characters, but leave a space instead of spaces. Here is an example: contentText - 12 44 33 43 , frontText - 2, backText - 4. Return Value: 12 ** ** 33 43
  if (contentText == null || frontText == null || backText == null) {
    return null;
  }

  if (contentText.length <= frontText + backText) {
    return contentText;
  }

  String front = contentText.substring(0, frontText);
  String back = contentText.substring(contentText.length - backText);

  String hidden = '';
  for (int i = frontText; i < contentText.length - backText; i++) {
    if (contentText[i] == ' ') {
      hidden += ' ';
    } else {
      hidden += '*';
    }
  }

  return '$front$hidden$back';
}

String? creditCardType(String? creditCard) {
  // by card number, give me the type of this card. For example, this is a Visa or Mastercard kata
  if (creditCard == null) {
    return null;
  }

  // Remove all non-digit characters from the credit card number
  String cleanedCardNumber = creditCard.replaceAll(RegExp(r'\D'), '');

  // Check the length of the cleaned credit card number to determine the type
  if (cleanedCardNumber.length == 0) {
    return null;
  } else if (cleanedCardNumber.length == 15 &&
          cleanedCardNumber.startsWith('34') ||
      cleanedCardNumber.startsWith('37')) {
    return 'American Express';
  } else if (cleanedCardNumber.length == 10) {
    if (cleanedCardNumber.startsWith('074') ||
        cleanedCardNumber.startsWith('075')) {
      return 'Vodacom M-Pesa';
    } else if (cleanedCardNumber.startsWith('071') ||
        cleanedCardNumber.startsWith('076')) {
      return 'Tigo Pesa';
    } else if (cleanedCardNumber.startsWith('078')) {
      return 'Airtel Money';
    } else if (cleanedCardNumber.startsWith('068')) {
      return 'Halopesa';
    }
    return 'Mobile Money (Tanzania)';
  } else {
    return 'Unknown';
  }
}

double? stringToDouble(String price) {
  // modify thus function to take this string  (Yearly For Tzs: 500,000) and return double
// Remove any non-numeric characters except for the decimal point
  String sanitizedPrice = price.replaceAll(RegExp(r'[^0-9.]'), '');
  // Convert the sanitized string to double
  return double.tryParse(sanitizedPrice);
}
