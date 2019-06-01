import 'package:reverb/res/res.dart';
import 'package:flutter/material.dart';


class InfitioCustomStyles {

  static const inputContentPadding = EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0);

  static final inputBorder = UnderlineInputBorder(
//    borderRadius: BorderRadius.circular(4.0), //Defaults to 4.0
      borderSide: BorderSide(color: InfitioColors.white_six, width: 1.0)
  );

  static final inputBorderNew = OutlineInputBorder(
//    borderRadius: BorderRadius.circular(4.0), //Defaults to 4.0
      borderSide: BorderSide(color:InfitioColors.white_seven, width: 1.0)
  );

  static final TextStyle inputHint = InfitioStyles.textStyle4
      .copyWith(color: InfitioStyles.textStyle4.color.withOpacity(0.5));

  static final TextStyle inputLabel = InfitioStyles.textStyle11
      .copyWith(color: InfitioStyles.textStyle11.color.withOpacity(0.7));

  static final TextStyle inputStyleDisable = InfitioStyles.textStyle8
      .copyWith(color: InfitioStyles.textStyle8.color.withOpacity(0.7));

  static final postDecoration = BoxDecoration(
    color: InfitioColors.white_seven,
//    border: Border.all(color: InfitioColors.dark_grey_blue_8),
    borderRadius: BorderRadius.circular(8.0),
    boxShadow: <BoxShadow>[
      BoxShadow(
          color: InfitioColors.black_8,
          blurRadius: 14.0,
          spreadRadius: -10.0,
          offset: Offset(0.0, 11.0))
    ],
  );

  static const textStyle46_opa60 = const TextStyle(
      color:   const Color(0x99273d52),
      fontWeight: FontWeight.w400,
      fontFamily: "SFProText",
      fontStyle:  FontStyle.normal,
      fontSize: 12.0
  );

  static const textStyle51_opa60 = const TextStyle(
      color:  const Color(0x99273d52),
      fontWeight: FontWeight.w300,
      fontFamily: "SFProText",
      fontStyle:  FontStyle.normal,
      fontSize: 12.0
  );

  static const textStyle45_opa90 = const TextStyle(
      color:  const Color(0xE6273d52),
      fontWeight: FontWeight.w700,
      fontFamily: "SFProText",
      fontStyle:  FontStyle.normal,
      fontSize: 14.0
  );

  static const textStyle58_opa90 = const TextStyle(
      color:  const Color(0xE6273d52),
      fontWeight: FontWeight.w500,
      fontFamily: "SFProText",
      fontStyle:  FontStyle.normal,
      fontSize: 14.0
  );

  static const textStyle58_opa60 = const TextStyle(
      color:  const Color(0x99273d52),
      fontWeight: FontWeight.w500,
      fontFamily: "SFProText",
      fontStyle:  FontStyle.normal,
      fontSize: 14.0
  );

  static const textStyle61_opa60 = const TextStyle(
      color:  const Color(0x99273d52),
      fontWeight: FontWeight.w400,
      fontFamily: "SFProText",
      fontStyle:  FontStyle.normal,
      fontSize: 14.0
  );

  static const textStyle47_opa50 = const TextStyle(
      color:  const Color(0x80273d52),
      fontWeight: FontWeight.w400,
      fontFamily: "SFProText",
      fontStyle:  FontStyle.normal,
      fontSize: 14.0
  );


  static const textStyle47_line_height = const TextStyle(
    color:  InfitioColors.dark_grey_blue,
    fontWeight: FontWeight.w400,
    fontFamily: "SFProText",
    fontStyle:  FontStyle.normal,
    fontSize: 14.0,
    height: 1.3
  );

  static const textStyle50_underline = const TextStyle(
      color:  InfitioColors.dark_grey_blue,
      fontWeight: FontWeight.w400,
      fontFamily: "SFProText",
      fontStyle:  FontStyle.normal,
      fontSize: 10.0,
      decoration: TextDecoration.underline
  );

  static const textStyleCategory = const TextStyle(
      color:  InfitioCustomColors.custom_orange,
      fontWeight: FontWeight.w400,
      fontFamily: "SFProText",
      fontStyle:  FontStyle.normal,
      fontSize: 9.0
  );

  static const textStyleCommentActions = const TextStyle(
      color:  InfitioColors.white_seven,
      fontWeight: FontWeight.w400,
      fontFamily: "SFProText",
      fontStyle:  FontStyle.normal,
      fontSize: 12.0
  );


  static const textStyle13 = const TextStyle(
      color:  InfitioCustomColors.white_seven_50,
      fontWeight: FontWeight.w500,
      fontFamily: "SFProText",
      fontStyle:  FontStyle.normal,
      fontSize: 16.0
  );

  static const textStyle72_opa30 = const TextStyle(
      color:  InfitioColors.black_8,
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
      fontStyle:  FontStyle.normal,
      fontSize: 16.0
  );

  static const newPost_normal = const TextStyle(
      color:  InfitioColors.dark_grey_blue,
      fontWeight: FontWeight.w400,
      fontFamily: "SFProText",
      fontStyle:  FontStyle.normal,
      fontSize: 14.0,
  );

  static const textMuted = const TextStyle(
    color:  Colors.black12,
    fontWeight: FontWeight.w400,
    fontFamily: "SFProText",
    fontStyle:  FontStyle.normal,
    fontSize: 18.0
  );

  static const textMutedLight = const TextStyle(
    color:  Colors.white70,
    fontWeight: FontWeight.w400,
    fontFamily: "SFProText",
    fontStyle:  FontStyle.normal,
    fontSize: 18.0
  );

  static const textMutedTinyLight = const TextStyle(
    color:  Colors.white70,
    fontWeight: FontWeight.w400,
    fontFamily: "SFProText",
    fontStyle:  FontStyle.normal,
    fontSize: 12.0
  );

  static const dialogTitle = const TextStyle(
      color:  InfitioColors.dark_grey_blue,
      fontWeight: FontWeight.w500,
      fontFamily: "SFProText",
      fontStyle:  FontStyle.normal,
      fontSize: 16.0
  );

  static const dialogContent = const TextStyle(
      color:  const Color(0x99334454),
      fontWeight: FontWeight.w400,
      fontFamily: "SFProText",
      fontStyle:  FontStyle.normal,
      fontSize: 14.0,
  );

  static const dialogButton = const TextStyle(
    color:  InfitioColors.dark_grey_blue,
    fontWeight: FontWeight.w500,
    fontFamily: "SFProText",
    fontStyle:  FontStyle.normal,
    fontSize: 14.0,
  );

}
