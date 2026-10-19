
package com.example.iraab

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.LayoutDirection
import androidx.compose.ui.platform.LocalLayoutDirection
import androidx.compose.ui.unit.dp

data class WordAnalysis(
    val word: String,
    val analysis: String
)

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContent {
            MaterialTheme {
                CompositionLocalProvider(
                    LocalLayoutDirection provides LayoutDirection.Rtl
                ) {
                    IraabApp()
                }
            }
        }
    }
}

@Composable
fun IraabApp() {
    var sentence by remember {
        mutableStateOf("قرأَ الطالبُ الكتابَ")
    }

    var result by remember {
        mutableStateOf<List<WordAnalysis>>(emptyList())
    }

    val examples = listOf(
        "قرأَ الطالبُ الكتابَ",
        "العلمُ نورٌ",
        "ذهبَ محمدٌ إلى المدرسةِ",
        "إنَّ الطالبَ مجتهدٌ",
        "كانَ الجوُّ جميلًا"
    )

    Scaffold(
        topBar = {
            CenterAlignedTopAppBar(
                title = { Text("إعراب") }
            )
        }
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .padding(20.dp)
                .verticalScroll(rememberScrollState()),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(
                text = "مساعدك في قواعد اللغة العربية",
                style = MaterialTheme.typography.titleMedium
            )

            Spacer(Modifier.height(20.dp))

            OutlinedTextField(
                value = sentence,
                onValueChange = { sentence = it },
                label = { Text("اكتب الجملة هنا") },
                modifier = Modifier.fillMaxWidth(),
                minLines = 2
            )

            Spacer(Modifier.height(12.dp))

            Button(
                onClick = {
                    result = parseSentence(sentence)
                },
                modifier = Modifier.fillMaxWidth()
            ) {
                Text("أعرب الجملة")
            }

            OutlinedButton(
                onClick = {
                    sentence = examples.random()
                    result = parseSentence(sentence)
                },
                modifier = Modifier.fillMaxWidth()
            ) {
                Text("جملة عشوائية")
            }

            Spacer(Modifier.height(20.dp))

            if (result.isNotEmpty()) {
                Text(
                    "نتيجة الإعراب",
                    style = MaterialTheme.typography.titleLarge
                )

                Spacer(Modifier.height(8.dp))

                result.forEach { item ->
                    Card(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(vertical = 4.dp)
                    ) {
                        Column(
                            modifier = Modifier.padding(12.dp)
                        ) {
                            Text(
                                text = item.word,
                                style = MaterialTheme.typography.titleMedium
                            )
                            Text(item.analysis)
                        }
                    }
                }
            } else {
                Text(
                    "اكتب جملة واضغط «أعرب الجملة» للبدء."
                )
            }

            Spacer(Modifier.height(16.dp))

            Text(
                text = "ملاحظة: هذه نسخة تجريبية بقواعد محدودة، " +
                    "وليست محللًا نحويًا شاملًا.",
                style = MaterialTheme.typography.bodySmall
            )
        }
    }
}

fun parseSentence(input: String): List<WordAnalysis> {
    val sentence = input.trim().replace(Regex("\\s+"), " ")

    if (sentence.isBlank()) return emptyList()

    return when (sentence) {
        "قرأَ الطالبُ الكتابَ" -> listOf(
            WordAnalysis("قرأَ", "فعل ماضٍ مبني على الفتح."),
            WordAnalysis("الطالبُ", "فاعل مرفوع وعلامة رفعه الضمة."),
            WordAnalysis("الكتابَ", "مفعول به منصوب وعلامة نصبه الفتحة.")
        )

        "العلمُ نورٌ" -> listOf(
            WordAnalysis("العلمُ", "مبتدأ مرفوع وعلامة رفعه الضمة."),
            WordAnalysis("نورٌ", "خبر مرفوع وعلامة رفعه الضمة.")
        )

        "ذهبَ محمدٌ إلى المدرسةِ" -> listOf(
            WordAnalysis("ذهبَ", "فعل ماضٍ مبني على الفتح."),
            WordAnalysis("محمدٌ", "فاعل مرفوع وعلامة رفعه الضمة."),
            WordAnalysis("إلى", "حرف جر."),
            WordAnalysis("المدرسةِ", "اسم مجرور بإلى وعلامة جره الكسرة.")
        )

        "إنَّ الطالبَ مجتهدٌ" -> listOf(
            WordAnalysis("إنَّ", "حرف توكيد ونصب."),
            WordAnalysis("الطالبَ", "اسم إنَّ منصوب وعلامة نصبه الفتحة."),
            WordAnalysis("مجتهدٌ", "خبر إنَّ مرفوع وعلامة رفعه الضمة.")
        )

        "كانَ الجوُّ جميلًا" -> listOf(
            WordAnalysis("كانَ", "فعل ماضٍ ناقص."),
            WordAnalysis("الجوُّ", "اسم كان مرفوع وعلامة رفعه الضمة."),
            WordAnalysis("جميلًا", "خبر كان منصوب وعلامة نصبه الفتحة.")
        )

        else -> listOf(
            WordAnalysis(
                sentence,
                "هذه الجملة غير موجودة في قاعدة الأمثلة الحالية. " +
                    "لا يمكن ضمان إعرابها الصحيح بهذه النسخة."
            )
        )
    }
}
