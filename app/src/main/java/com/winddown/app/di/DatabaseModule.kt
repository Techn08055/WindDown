package com.winddown.app.di

import android.content.Context
import androidx.room.Room
import com.winddown.app.data.local.WindDownDatabase
import com.winddown.app.data.local.dao.CalmItemDao
import com.winddown.app.data.local.dao.SettingsDao
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object DatabaseModule {
    
    @Provides
    @Singleton
    fun provideWindDownDatabase(
        @ApplicationContext context: Context
    ): WindDownDatabase {
        return Room.databaseBuilder(
            context,
            WindDownDatabase::class.java,
            "winddown_database"
        ).build()
    }
    
    @Provides
    @Singleton
    fun provideCalmItemDao(database: WindDownDatabase): CalmItemDao {
        return database.calmItemDao()
    }
    
    @Provides
    @Singleton
    fun provideSettingsDao(database: WindDownDatabase): SettingsDao {
        return database.settingsDao()
    }
}






