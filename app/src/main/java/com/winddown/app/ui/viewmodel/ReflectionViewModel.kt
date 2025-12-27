package com.winddown.app.ui.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.winddown.app.data.repository.WindDownRepository
import com.winddown.app.ui.state.ReflectionUiState
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class ReflectionViewModel @Inject constructor(
    private val repository: WindDownRepository
) : ViewModel() {
    
    private val _uiState = MutableStateFlow(ReflectionUiState())
    val uiState: StateFlow<ReflectionUiState> = _uiState.asStateFlow()
    
    init {
        loadData()
    }
    
    private fun loadData() {
        viewModelScope.launch {
            combine(
                repository.getAllCalmItems(),
                repository.getSettings()
            ) { items, settings ->
                ReflectionUiState(
                    calmItems = items,
                    trustModeEnabled = settings?.trustModeEnabled ?: false,
                    isLoading = false
                )
            }.collect { state ->
                _uiState.value = state
            }
        }
    }
    
    fun toggleItem(itemId: Long) {
        viewModelScope.launch {
            repository.toggleCalmItem(itemId)
        }
    }
    
    fun completeDay(onComplete: () -> Unit) {
        viewModelScope.launch {
            repository.markDayComplete()
            onComplete()
        }
    }
}






