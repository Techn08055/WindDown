package com.winddown.app.ui.screens

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.hilt.navigation.compose.hiltViewModel
import com.winddown.app.ui.components.BreathingAnimation
import com.winddown.app.ui.components.WindDownButton
import com.winddown.app.ui.theme.AccentPurple
import com.winddown.app.ui.theme.BackgroundDark
import com.winddown.app.ui.theme.BackgroundDeep
import com.winddown.app.ui.theme.BackgroundGradientEnd
import com.winddown.app.ui.theme.TextWhite
import com.winddown.app.ui.viewmodel.SummaryViewModel

@Composable
fun SummaryScreen(
    onNavigateBack: () -> Unit,
    viewModel: SummaryViewModel = hiltViewModel()
) {
    val uiState by viewModel.uiState.collectAsState()
    
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(
                brush = Brush.verticalGradient(
                    colors = listOf(
                        BackgroundDeep,
                        BackgroundDark,
                        BackgroundGradientEnd
                    )
                )
            )
    ) {
        AnimatedVisibility(
            visible = !uiState.isLoading,
            enter = fadeIn(),
            exit = fadeOut()
        ) {
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(24.dp),
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.SpaceBetween
            ) {
                Spacer(modifier = Modifier.height(64.dp))
                
                // Top content
                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .weight(1f),
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.Top
                ) {
                    // Status text
                    Text(
                        text = if (uiState.isRevisit) {
                            "You already wrapped up tonight."
                        } else {
                            "You wrapped up at ${uiState.completionTime}."
                        },
                        style = MaterialTheme.typography.displayMedium.copy(
                            fontWeight = FontWeight.Bold,
                            fontSize = 28.sp
                        ),
                        color = TextWhite,
                        textAlign = TextAlign.Center,
                        modifier = Modifier.padding(bottom = 8.dp)
                    )
                    
                    Text(
                        text = if (uiState.isRevisit) {
                            "Try a deep breath instead?"
                        } else {
                            "You're safe to rest."
                        },
                        style = MaterialTheme.typography.bodyLarge.copy(
                            fontSize = 18.sp
                        ),
                        color = TextWhite.copy(alpha = 0.8f),
                        textAlign = TextAlign.Center,
                        modifier = Modifier.padding(bottom = 24.dp)
                    )
                    
                    // Breathing animation
                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .weight(1f),
                        contentAlignment = Alignment.Center
                    ) {
                        BreathingAnimation()
                    }
                }
                
                // Bottom reassuring message (only show on first completion)
                if (!uiState.isRevisit) {
                    Column(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        Text(
                            text = "You've done enough for today.",
                            style = MaterialTheme.typography.bodyLarge.copy(
                                fontSize = 18.sp,
                                fontWeight = FontWeight.Medium
                            ),
                            color = TextWhite.copy(alpha = 0.9f),
                            textAlign = TextAlign.Center,
                            modifier = Modifier.padding(bottom = 12.dp)
                        )
                        
                        Text(
                            text = "Everything is settled. You can rest now.",
                            style = MaterialTheme.typography.bodyMedium.copy(
                                fontSize = 16.sp
                            ),
                            color = TextWhite.copy(alpha = 0.7f),
                            textAlign = TextAlign.Center,
                            modifier = Modifier.padding(bottom = 8.dp)
                        )
                        
                        Text(
                            text = "🌙 Sleep well. You're safe.",
                            style = MaterialTheme.typography.bodyLarge.copy(
                                fontSize = 18.sp,
                                fontWeight = FontWeight.Bold
                            ),
                            color = AccentPurple,
                            textAlign = TextAlign.Center
                        )
                    }
                }
                
                Spacer(modifier = Modifier.height(32.dp))
            }
        }
    }
}

