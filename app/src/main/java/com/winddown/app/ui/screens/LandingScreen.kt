package com.winddown.app.ui.screens

import androidx.compose.animation.core.*
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.NightsStay
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.draw.scale
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.winddown.app.ui.components.StarryBackground
import com.winddown.app.ui.components.WindDownButton
import com.winddown.app.ui.theme.BackgroundDeep
import com.winddown.app.ui.theme.BackgroundDark
import com.winddown.app.ui.theme.BackgroundGradientEnd
import com.winddown.app.ui.theme.TextPrimary

@Composable
fun LandingScreen(
    onBeginWindDown: () -> Unit
) {
    val infiniteTransition = rememberInfiniteTransition(label = "moon")
    
    val moonScale by infiniteTransition.animateFloat(
        initialValue = 1f,
        targetValue = 1.1f,
        animationSpec = infiniteRepeatable(
            animation = tween(durationMillis = 3000, easing = LinearEasing),
            repeatMode = RepeatMode.Reverse
        ),
        label = "moonScale"
    )
    
    val moonAlpha by infiniteTransition.animateFloat(
        initialValue = 0.8f,
        targetValue = 1f,
        animationSpec = infiniteRepeatable(
            animation = tween(durationMillis = 2000, easing = LinearEasing),
            repeatMode = RepeatMode.Reverse
        ),
        label = "moonAlpha"
    )
    
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
        // Starry background
        StarryBackground()
        
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(24.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.SpaceBetween
        ) {
            // Top section with moon and text
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .weight(1f)
                    .padding(top = 64.dp),
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.Center
            ) {
                // Moon icon
                Icon(
                    imageVector = Icons.Default.NightsStay,
                    contentDescription = "Moon",
                    modifier = Modifier
                        .size(144.dp)
                        .scale(moonScale)
                        .alpha(moonAlpha)
                        .padding(bottom = 32.dp),
                    tint = TextPrimary
                )
                
                // Title
                Text(
                    text = "WindDown",
                    style = MaterialTheme.typography.displayLarge.copy(
                        fontWeight = FontWeight.Bold,
                        fontSize = 32.sp
                    ),
                    color = TextPrimary,
                    textAlign = TextAlign.Center,
                    modifier = Modifier.padding(bottom = 12.dp)
                )
                
                // Subtitle
                Text(
                    text = "Ease into rest, not reassurance.",
                    style = MaterialTheme.typography.bodyLarge.copy(
                        fontSize = 16.sp
                    ),
                    color = TextPrimary,
                    textAlign = TextAlign.Center,
                    modifier = Modifier.padding(horizontal = 16.dp)
                )
            }
            
            // Bottom button
            WindDownButton(
                text = "Begin WindDown",
                onClick = onBeginWindDown,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(bottom = 32.dp)
            )
        }
    }
}






