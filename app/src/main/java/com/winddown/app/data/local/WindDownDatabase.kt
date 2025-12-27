package com.winddown.app.data.local

import androidx.room.Database
import androidx.room.RoomDatabase
import com.winddown.app.data.local.dao.CalmItemDao
import com.winddown.app.data.local.dao.SettingsDao
import com.winddown.app.data.local.entity.CalmItem
import com.winddown.app.data.local.entity.Settings

@Database(
    entities = [CalmItem::class, Settings::class],
    version = 1,
    exportSchema = false
)
abstract class WindDownDatabase : RoomDatabase() {
    abstract fun calmItemDao(): CalmItemDao
    abstract fun settingsDao(): SettingsDao
}






