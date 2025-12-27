package com.winddown.app.ui.components

import androidx.compose.animation.core.*
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import kotlin.random.Random

@Composable
fun StarryBackground(modifier: Modifier = Modifier) {
    val infiniteTransition = rememberInfiniteTransition(label = "stars")
    
    val twinkle by infiniteTransition.animateFloat(
        initialValue = 0f,
        targetValue = 1f,
        animationSpec = infiniteRepeatable(
            animation = tween(durationMillis = 3000, easing = LinearEasing),
            repeatMode = RepeatMode.Reverse
        ),
        label = "twinkle"
    )
    
    Canvas(modifier = modifier.fillMaxSize()) {
        val random = Random(42) // Fixed seed for consistent stars
        
        repeat(50) {
            val x = random.nextFloat() * size.width
            val y = random.nextFloat() * size.height
            val starAlpha = (random.nextFloat() * 0.3f + 0.2f) * (0.5f + twinkle * 0.5f)
            val starRadius = random.nextFloat() * 2f + 1f
            
            drawCircle(
                color = Color.White.copy(alpha = starAlpha),
                radius = starRadius,
                center = Offset(x, y)
            )
        }
    }
}






