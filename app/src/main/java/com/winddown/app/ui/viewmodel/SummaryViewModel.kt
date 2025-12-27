package com.winddown.app.ui.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.winddown.app.data.repository.WindDownRepository
import com.winddown.app.ui.state.SummaryUiState
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class SummaryViewModel @Inject constructor(
    private val repository: WindDownRepository
) : ViewModel() {
    
    private val _uiState = MutableStateFlow(SummaryUiState())
    val uiState: StateFlow<SummaryUiState> = _uiState.asStateFlow()
    
    init {
        loadData()
    }
    
    private fun loadData() {
        viewModelScope.launch {
            repository.getSettings()
                .map { settings ->
                    SummaryUiState(
                        completionTime = settings?.completionTime ?: "",
                        isRevisit = settings?.completedToday == true,
                        isLoading = false
                    )
                }
                .collect { state ->
                    _uiState.value = state
                }
        }
    }
}






