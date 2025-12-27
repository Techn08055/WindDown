package com.winddown.app.data.local.dao

import androidx.room.*
import com.winddown.app.data.local.entity.Settings
import kotlinx.coroutines.flow.Flow

@Dao
interface SettingsDao {
    @Query("SELECT * FROM settings WHERE id = 1")
    fun getSettings(): Flow<Settings?>
    
    @Query("SELECT * FROM settings WHERE id = 1")
    suspend fun getSettingsOnce(): Settings?
    
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertSettings(settings: Settings)
    
    @Update
    suspend fun updateSettings(settings: Settings)
    
    @Query("UPDATE settings SET bedtimeHour = :hour, bedtimeMinute = :minute WHERE id = 1")
    suspend fun updateBedtime(hour: Int, minute: Int)
    
    @Query("UPDATE settings SET trustModeEnabled = :enabled WHERE id = 1")
    suspend fun updateTrustMode(enabled: Boolean)
    
    @Query("UPDATE settings SET completedToday = :completed, completionTime = :time, lastCompletionDate = :date WHERE id = 1")
    suspend fun updateCompletionStatus(completed: Boolean, time: String?, date: String?)
}






