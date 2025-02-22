import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talabat/core/serviceLocater.dart';
import 'package:talabat/services/service.dart';

class LanguageState {
final bool isEnglish;
final Map<String, dynamic>? lang;
final Map<String, dynamic>? translation;


LanguageState({
  required this.isEnglish,
  required this.lang,
  required this.translation,
});

factory LanguageState.initial() => LanguageState(
        isEnglish: true,
        lang: {},
        translation: {},
      );
LanguageState copyWith({
    Map<String, dynamic>? lang,
    bool? isEnglish,
    Map<String, dynamic>? translation,
  }) {
    return LanguageState(
       lang: lang ?? this.lang,
       isEnglish: isEnglish ?? this.isEnglish,
       translation: translation ?? this.translation,
       
    );
  }  

}

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit(): super(LanguageState.initial());
  final cubit=getIt<ApiService>();
  void setupLanguage(Map<String, dynamic> lang){
    final defaultLanguage = lang['en'];
    emit(state.copyWith(lang: defaultLanguage,translation: lang));
  }
  Future<void> toggleLanguage(bool isEnglish) async{
    Map<String, dynamic> upgradelang;
    if(isEnglish){
     upgradelang = state.translation!['en'];
    }
    else{
      upgradelang=state.translation!['ar'];
    }
    emit(state.copyWith(isEnglish: isEnglish,lang: upgradelang));
    await cubit.setHeaders(state.isEnglish? 'en' : 'ar');
  }
}