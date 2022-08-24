// SPDX-FileCopyrightText: 2022 Freek van de Ven freek@freekvandeven.nl
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:flutter/material.dart';

@immutable
class Actor {
  const Actor({
    required this.name,
    required this.image,
  });
  final String name;
  final String image;
}
