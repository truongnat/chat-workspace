import '../../domain/entities/app_theme_data.dart';

class AppThemeDataModel extends AppThemeData {
  const AppThemeDataModel({
    required super.bubbleColorSent,
    required super.bubbleColorReceived,
    required super.backgroundColor,
    required super.surfaceColor,
    super.fontFamily,
  });

  factory AppThemeDataModel.fromJson(Map<String, dynamic> json) {
    return AppThemeDataModel(
      bubbleColorSent: Color(json['bubbleColorSent'] as int),
      bubbleColorReceived: Color(json['bubbleColorReceived'] as int),
      backgroundColor: Color(json['backgroundColor'] as int),
      surfaceColor: Color(json['surfaceColor'] as int),
      fontFamily: json['fontFamily'] as String? ?? 'Inter',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bubbleColorSent': bubbleColorSent.value,
      'bubbleColorReceived': bubbleColorReceived.value,
      'backgroundColor': backgroundColor.value,
      'surfaceColor': surfaceColor.value,
      'fontFamily': fontFamily,
    };
  }

  factory AppThemeDataModel.fromEntity(AppThemeData theme) {
    return AppThemeDataModel(
      bubbleColorSent: theme.bubbleColorSent,
      bubbleColorReceived: theme.bubbleColorReceived,
      backgroundColor: theme.backgroundColor,
      surfaceColor: theme.surfaceColor,
      fontFamily: theme.fontFamily,
    );
  }
}
