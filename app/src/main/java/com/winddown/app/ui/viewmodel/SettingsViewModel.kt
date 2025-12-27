package com.winddown.app.ui.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.winddown.app.data.repository.WindDownRepository
import com.winddown.app.ui.state.SettingsUiState
import com.winddown.app.worker.NotificationScheduler
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class SettingsViewModel @Inject constructor(
    private val repository: WindDownRepository,
    private val notificationScheduler: NotificationScheduler
) : ViewModel() {
    
    private val _uiState = MutableStateFlow(SettingsUiState())
    val uiState: StateFlow<SettingsUiState> = _uiState.asStateFlow()
    
    init {
        loadData()
    }
    
    private fun loadData() {
        viewModelScope.launch {
            combine(
                repository.getAllCalmItems(),
                repository.getSettings()
            ) { items, settings ->
                SettingsUiState(
                    bedtimeHour = settings?.bedtimeHour ?: 22,
                    bedtimeMinute = settings?.bedtimeMinute ?: 30,
                    trustModeEnabled = settings?.trustModeEnabled ?: false,
                    calmItems = items,
                    isLoading = false
                )
            }.collect { state ->
                _uiState.value = state
            }
        }
    }
    
    fun updateBedtime(hour: Int, minute: Int) {
        viewModelScope.launch {
            // Update database first
            repository.updateBedtime(hour, minute)
            // Update UI state immediately
            _uiState.update { it.copy(bedtimeHour = hour, bedtimeMinute = minute) }
            // Schedule notification after state update
            notificationScheduler.scheduleBedtimeNotification(hour, minute)
        }
    }
    
    fun updateTrustMode(enabled: Boolean) {
        viewModelScope.launch {
            repository.updateTrustMode(enabled)
            // Update UI state immediately
            _uiState.update { it.copy(trustModeEnabled = enabled) }
        }
    }
    
    fun addCalmItem(text: String) {
        if (text.isBlank()) return
        viewModelScope.launch {
            repository.addCalmItem(text)
            _uiState.update { it.copy(newItemText = "") }
        }
    }
    
    fun deleteCalmItem(itemId: Long) {
        viewModelScope.launch {
            repository.deleteCalmItem(itemId)
        }
    }
    
    fun updateNewItemText(text: String) {
        _uiState.update { it.copy(newItemText = text) }
    }
}


