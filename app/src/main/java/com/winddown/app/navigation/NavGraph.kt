package com.winddown.app.navigation

import androidx.compose.runtime.Composable
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import com.winddown.app.ui.screens.LandingScreen
import com.winddown.app.ui.screens.ReflectionScreen
import com.winddown.app.ui.screens.SummaryScreen

sealed class Screen(val route: String) {
    object Landing : Screen("landing")
    object Reflection : Screen("reflection")
    object Summary : Screen("summary")
}

@Composable
fun NavGraph(
    navController: NavHostController,
    startDestination: String = Screen.Landing.route
) {
    NavHost(
        navController = navController,
        startDestination = startDestination
    ) {
        composable(Screen.Landing.route) {
            LandingScreen(
                onBeginWindDown = {
                    navController.navigate(Screen.Reflection.route) {
                        popUpTo(Screen.Landing.route) { inclusive = false }
                    }
                }
            )
        }
        
        composable(Screen.Reflection.route) {
            ReflectionScreen(
                onCloseDay = {
                    navController.navigate(Screen.Summary.route) {
                        popUpTo(Screen.Reflection.route) { inclusive = true }
                    }
                }
            )
        }
        
        composable(Screen.Summary.route) {
            SummaryScreen(
                onNavigateBack = {
                    navController.popBackStack()
                }
            )
        }
    }
}






