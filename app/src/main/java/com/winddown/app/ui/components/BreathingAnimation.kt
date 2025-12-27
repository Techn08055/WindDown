package com.winddown.app.ui.components

import androidx.compose.animation.core.*
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.winddown.app.ui.theme.AccentPurple
import com.winddown.app.ui.theme.TextWhite

@Composable
fun BreathingAnimation(modifier: Modifier = Modifier) {
    val infiniteTransition = rememberInfiniteTransition(label = "breathing")
    
    val scale by infiniteTransition.animateFloat(
        initialValue = 0.8f,
        targetValue = 1.2f,
        animationSpec = infiniteRepeatable(
            animation = tween(durationMillis = 4000, easing = LinearEasing),
            repeatMode = RepeatMode.Reverse
        ),
        label = "scale"
    )
    
    val phase by infiniteTransition.animateFloat(
        initialValue = 0f,
        targetValue = 1f,
        animationSpec = infiniteRepeatable(
            animation = tween(durationMillis = 8000, easing = LinearEasing),
            repeatMode = RepeatMode.Restart
        ),
        label = "phase"
    )
    
    Box(
        modifier = modifier
            .size(256.dp)
            .fillMaxSize(),
        contentAlignment = Alignment.Center
    ) {
        // Outer circle
        Box(
            modifier = Modifier
                .size(256.dp * scale)
                .background(AccentPurple.copy(alpha = 0.2f), CircleShape)
        )
        
        // Middle circle
        Box(
            modifier = Modifier
                .size(192.dp * scale)
                .background(AccentPurple.copy(alpha = 0.4f), CircleShape)
        )
        
        // Inner circle
        Box(
            modifier = Modifier
                .size(128.dp * scale)
                .background(AccentPurple.copy(alpha = 0.6f), CircleShape)
        )
        
        // Text
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            Text(
                text = if (phase < 0.5f) "Inhale..." else "Exhale...",
                style = MaterialTheme.typography.titleLarge.copy(
                    fontWeight = FontWeight.Bold,
                    fontSize = 18.sp
                ),
                color = TextWhite,
                modifier = Modifier.alpha(if (phase < 0.5f) 1f else 0.6f)
            )
            
            Text(
                text = if (phase < 0.5f) "" else "Let go...",
                style = MaterialTheme.typography.bodyMedium.copy(
                    fontSize = 14.sp
                ),
                color = TextWhite.copy(alpha = 0.8f),
                modifier = Modifier.alpha(if (phase < 0.5f) 0f else 1f)
            )
        }
    }
}






