package com.winddown.app.data.local.dao

import androidx.room.*
import com.winddown.app.data.local.entity.CalmItem
import kotlinx.coroutines.flow.Flow

@Dao
interface CalmItemDao {
    @Query("SELECT * FROM calm_items ORDER BY `order` ASC")
    fun getAllItems(): Flow<List<CalmItem>>
    
    @Query("SELECT * FROM calm_items WHERE id = :id")
    suspend fun getItemById(id: Long): CalmItem?
    
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertItem(item: CalmItem): Long
    
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertItems(items: List<CalmItem>)
    
    @Update
    suspend fun updateItem(item: CalmItem)
    
    @Delete
    suspend fun deleteItem(item: CalmItem)
    
    @Query("DELETE FROM calm_items WHERE id = :id")
    suspend fun deleteItemById(id: Long)
    
    @Query("UPDATE calm_items SET isChecked = :isChecked WHERE id = :id")
    suspend fun updateCheckedState(id: Long, isChecked: Boolean)
    
    @Query("UPDATE calm_items SET isChecked = 0")
    suspend fun uncheckAllItems()
    
    @Query("SELECT COUNT(*) FROM calm_items")
    suspend fun getCount(): Int
}






