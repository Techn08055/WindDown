package com.winddown.app.data.repository

import com.winddown.app.data.local.dao.CalmItemDao
import com.winddown.app.data.local.dao.SettingsDao
import com.winddown.app.data.local.entity.CalmItem
import com.winddown.app.data.local.entity.Settings
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.firstOrNull
import java.time.LocalDate
import java.time.LocalTime
import java.time.format.DateTimeFormatter
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class WindDownRepository @Inject constructor(
    private val calmItemDao: CalmItemDao,
    private val settingsDao: SettingsDao
) {
    // Calm Items
    fun getAllCalmItems(): Flow<List<CalmItem>> = calmItemDao.getAllItems()
    
    suspend fun addCalmItem(text: String) {
        val count = calmItemDao.getCount()
        calmItemDao.insertItem(CalmItem(text = text, order = count))
    }
    
    suspend fun deleteCalmItem(id: Long) {
        calmItemDao.deleteItemById(id)
    }
    
    suspend fun toggleCalmItem(id: Long) {
        val item = calmItemDao.getItemById(id)
        item?.let {
            calmItemDao.updateCheckedState(id, !it.isChecked)
        }
    }
    
    suspend fun uncheckAllItems() {
        calmItemDao.uncheckAllItems()
    }
    
    suspend fun initializeDefaultItems() {
        val count = calmItemDao.getCount()
        if (count == 0) {
            val defaultItems = listOf(
                CalmItem(text = "Home feels safe.", order = 0),
                CalmItem(text = "Kitchen is settled.", order = 1),
                CalmItem(text = "Water's off, day's off.", order = 2),
                CalmItem(text = "Mind ready for rest.", order = 3)
            )
            calmItemDao.insertItems(defaultItems)
        }
    }
    
    // Settings
    fun getSettings(): Flow<Settings?> = settingsDao.getSettings()
    
    suspend fun getSettingsOnce(): Settings {
        return settingsDao.getSettingsOnce() ?: Settings().also {
            settingsDao.insertSettings(it)
        }
    }
    
    suspend fun updateBedtime(hour: Int, minute: Int) {
        settingsDao.updateBedtime(hour, minute)
    }
    
    suspend fun updateTrustMode(enabled: Boolean) {
        settingsDao.updateTrustMode(enabled)
    }
    
    suspend fun markDayComplete() {
        val currentTime = LocalTime.now()
        val currentDate = LocalDate.now()
        val formatter = DateTimeFormatter.ofPattern("h:mm a")
        val timeString = currentTime.format(formatter)
        val dateString = currentDate.toString()
        
        settingsDao.updateCompletionStatus(true, timeString, dateString)
        uncheckAllItems()
    }
    
    suspend fun checkAndResetCompletion() {
        val settings = settingsDao.getSettingsOnce()
        settings?.let {
            val today = LocalDate.now().toString()
            if (it.lastCompletionDate != today && it.completedToday) {
                settingsDao.updateCompletionStatus(false, null, null)
            }
        }
    }
    
    suspend fun initializeSettings() {
        val settings = settingsDao.getSettings().firstOrNull()
        if (settings == null) {
            settingsDao.insertSettings(Settings())
        }
    }
}






