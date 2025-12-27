package com.winddown.app.ui.screens

import android.widget.Toast
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import com.winddown.app.ui.components.CalmCard
import com.winddown.app.ui.components.WindDownButton
import com.winddown.app.ui.screens.settings.SettingsDialog
import com.winddown.app.ui.theme.BackgroundDark
import com.winddown.app.ui.theme.BackgroundDeep
import com.winddown.app.ui.theme.TextPrimary
import com.winddown.app.ui.viewmodel.ReflectionViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ReflectionScreen(
    onCloseDay: () -> Unit,
    viewModel: ReflectionViewModel = hiltViewModel()
) {
    val uiState by viewModel.uiState.collectAsState()
    val context = LocalContext.current
    var showSettings by remember { mutableStateOf(false) }
    
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(
                brush = Brush.verticalGradient(
                    colors = listOf(
                        BackgroundDark,
                        BackgroundDeep
                    )
                )
            )
    ) {
        Column(
            modifier = Modifier.fillMaxSize()
        ) {
            // Header
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(top = 64.dp, bottom = 24.dp, start = 24.dp, end = 24.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.End
                ) {
                    IconButton(onClick = { showSettings = true }) {
                        Icon(
                            imageVector = Icons.Default.Settings,
                            contentDescription = "Settings",
                            tint = TextPrimary
                        )
                    }
                }
                
                Text(
                    text = "🌙 Ready to wind down?",
                    style = MaterialTheme.typography.displayLarge.copy(
                        fontWeight = FontWeight.Bold,
                        fontSize = 32.sp
                    ),
                    color = TextPrimary,
                    textAlign = TextAlign.Center,
                    modifier = Modifier.padding(bottom = 8.dp)
                )
                
                Text(
                    text = "You've done enough for today.",
                    style = MaterialTheme.typography.bodyLarge.copy(
                        fontSize = 16.sp
                    ),
                    color = TextPrimary.copy(alpha = 0.8f),
                    textAlign = TextAlign.Center
                )
            }
            
            // Content
            AnimatedVisibility(
                visible = !uiState.isLoading,
                enter = fadeIn(),
                exit = fadeOut()
            ) {
                LazyColumn(
                    modifier = Modifier
                        .weight(1f)
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp),
                    verticalArrangement = Arrangement.spacedBy(12.dp)
                ) {
                    items(uiState.calmItems, key = { it.id }) { item ->
                        CalmCard(
                            item = item,
                            onToggle = {
                                viewModel.toggleItem(item.id)
                                if (!item.isChecked) {
                                    Toast.makeText(
                                        context,
                                        "That's one less thing to carry tonight.",
                                        Toast.LENGTH_SHORT
                                    ).show()
                                }
                            }
                        )
                    }
                    
                    // Bottom padding for gradient
                    item {
                        Spacer(modifier = Modifier.height(100.dp))
                    }
                }
            }
        }
        
        // Footer with gradient and button
        Box(
            modifier = Modifier
                .align(Alignment.BottomCenter)
                .fillMaxWidth()
                .background(
                    brush = Brush.verticalGradient(
                        colors = listOf(
                            Color.Transparent,
                            BackgroundDeep.copy(alpha = 0.9f),
                            BackgroundDeep
                        )
                    )
                )
                .padding(top = 32.dp, bottom = 32.dp, start = 16.dp, end = 16.dp)
        ) {
            WindDownButton(
                text = "Close the Day",
                onClick = {
                    viewModel.completeDay(onCloseDay)
                },
                modifier = Modifier.fillMaxWidth()
            )
        }
    }
    
    if (showSettings) {
        SettingsDialog(onDismiss = { showSettings = false })
    }
}






