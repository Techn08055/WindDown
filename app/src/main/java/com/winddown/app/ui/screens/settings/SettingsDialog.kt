package com.winddown.app.ui.screens.settings

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.lazy.rememberLazyListState
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.VerifiedUser
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.window.Dialog
import androidx.compose.ui.window.DialogProperties
import androidx.hilt.navigation.compose.hiltViewModel
import com.winddown.app.ui.components.WindDownButton
import com.winddown.app.ui.theme.*
import com.winddown.app.ui.viewmodel.SettingsViewModel

@Composable
fun SettingsDialog(
    onDismiss: () -> Unit,
    viewModel: SettingsViewModel = hiltViewModel()
) {
    val uiState by viewModel.uiState.collectAsState()
    
    Dialog(
        onDismissRequest = onDismiss,
        properties = DialogProperties(usePlatformDefaultWidth = false)
    ) {
        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(Color.Black.copy(alpha = 0.4f))
                .clickable(onClick = onDismiss),
            contentAlignment = Alignment.BottomCenter
        ) {
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .heightIn(max = 600.dp) // Limit max height
                    .clickable(enabled = false) { }
                    .clip(RoundedCornerShape(topStart = 24.dp, topEnd = 24.dp))
                    .background(
                        brush = Brush.verticalGradient(
                            colors = listOf(
                                Color(0xFF2a2958),
                                Color(0xFF191D3A)
                            )
                        )
                    )
            ) {
                Column(
                    modifier = Modifier.fillMaxSize()
                ) {
                    // Bottom sheet handle
                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(top = 12.dp),
                        contentAlignment = Alignment.Center
                    ) {
                        Box(
                            modifier = Modifier
                                .width(36.dp)
                                .height(4.dp)
                                .clip(RoundedCornerShape(2.dp))
                                .background(Color.White.copy(alpha = 0.2f))
                        )
                    }
                    
                    LazyColumn(
                        modifier = Modifier
                            .fillMaxWidth()
                            .weight(1f)
                            .padding(horizontal = 16.dp),
                        verticalArrangement = Arrangement.spacedBy(0.dp)
                    ) {
                        item {
                            // Title
                            Text(
                                text = "Settings",
                                style = MaterialTheme.typography.displayLarge.copy(
                                    fontWeight = FontWeight.Bold,
                                    fontSize = 32.sp
                                ),
                                color = TextPrimary,
                                textAlign = androidx.compose.ui.text.style.TextAlign.Center,
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .padding(vertical = 24.dp)
                            )
                        }
                        
                        item {
                            // Bedtime section
                            Column(modifier = Modifier.padding(bottom = 32.dp)) {
                                Text(
                                    text = "Set Your Bedtime",
                                    style = MaterialTheme.typography.headlineLarge.copy(
                                        fontWeight = FontWeight.Bold,
                                        fontSize = 22.sp
                                    ),
                                    color = TextPrimary,
                                    modifier = Modifier.padding(bottom = 12.dp)
                                )
                                
                                ScrollableTimePicker(
                                    hour = uiState.bedtimeHour,
                                    minute = uiState.bedtimeMinute,
                                    onTimeChanged = { hour, minute ->
                                        viewModel.updateBedtime(hour, minute)
                                    }
                                )
                            }
                        }
                        
                        item {
                            // Trust mode section
                            TrustModeToggle(
                                enabled = uiState.trustModeEnabled,
                                onToggle = { viewModel.updateTrustMode(it) },
                                modifier = Modifier.padding(bottom = 32.dp)
                            )
                        }

                        item {
                            // Calm list section
                            Text(
                                text = "Your Calm List",
                                style = MaterialTheme.typography.headlineLarge.copy(
                                    fontWeight = FontWeight.Bold,
                                    fontSize = 22.sp
                                ),
                                color = TextPrimary,
                                modifier = Modifier.padding(bottom = 4.dp)
                            )
                            
                            Text(
                                text = "Add items you find reassuring.",
                                style = MaterialTheme.typography.bodyMedium.copy(
                                    fontSize = 14.sp
                                ),
                                color = TextSecondary,
                                modifier = Modifier.padding(bottom = 12.dp)
                            )
                        }

                        items(uiState.calmItems, key = { it.id }) { item ->
                            CalmListItem(
                                text = item.text,
                                onDelete = { viewModel.deleteCalmItem(item.id) },
                                modifier = Modifier.padding(bottom = 8.dp)
                            )
                        }

                        item {
                            // Add item input
                            AddItemInput(
                                value = uiState.newItemText,
                                onValueChange = { viewModel.updateNewItemText(it) },
                                onAdd = {
                                    if (uiState.newItemText.isNotBlank()) {
                                        viewModel.addCalmItem(uiState.newItemText)
                                    }
                                },
                                modifier = Modifier.padding(bottom = 16.dp)
                            )
                        }
                        
                        // Done button - at bottom of LazyColumn
                        item {
                            WindDownButton(
                                text = "Done",
                                onClick = onDismiss,
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .padding(vertical = 24.dp, horizontal = 16.dp),
                                backgroundColor = PrimaryLight
                            )
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun ScrollableTimePicker(
    hour: Int,
    minute: Int,
    onTimeChanged: (Int, Int) -> Unit,
    modifier: Modifier = Modifier
) {
    // Convert 24h to 12h format for display
    val displayHour = when {
        hour == 0 -> 12
        hour > 12 -> hour - 12
        else -> hour
    }
    val isPM = hour >= 12
    
    var selectedHour by remember(hour) { mutableIntStateOf(displayHour) }
    var selectedMinute by remember(minute) { mutableIntStateOf(minute) }
    var selectedAMPM by remember(hour) { mutableStateOf(if (isPM) "PM" else "AM") }
    
    // Update when props change
    LaunchedEffect(hour, minute) {
        val newDisplayHour = when {
            hour == 0 -> 12
            hour > 12 -> hour - 12
            else -> hour
        }
        selectedHour = newDisplayHour
        selectedMinute = minute
        selectedAMPM = if (hour >= 12) "PM" else "AM"
    }
    
    // Display current selected time clearly
    val currentTimeText = remember(selectedHour, selectedMinute, selectedAMPM) {
        String.format("%d:%02d %s", selectedHour, selectedMinute, selectedAMPM)
    }
    
    Column(modifier = modifier) {
        // Display selected time
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .clip(RoundedCornerShape(8.dp))
                .background(PrimaryLight.copy(alpha = 0.15f))
                .padding(vertical = 12.dp, horizontal = 16.dp),
            contentAlignment = Alignment.Center
        ) {
            Text(
                text = currentTimeText,
                style = MaterialTheme.typography.headlineLarge.copy(
                    fontSize = 24.sp,
                    fontWeight = FontWeight.Bold
                ),
                color = TextPrimary
            )
        }
        
        Spacer(modifier = Modifier.height(16.dp))
        
        // Time picker wheels - smooth scrolling with all minutes
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .height(240.dp)
                .clip(RoundedCornerShape(12.dp))
                .background(SurfaceDark.copy(alpha = 0.6f))
        ) {
            Row(
                modifier = Modifier.fillMaxSize(),
                horizontalArrangement = Arrangement.SpaceEvenly,
                verticalAlignment = Alignment.CenterVertically
            ) {
                // Hour picker
                WheelPicker(
                    items = (1..12).toList(),
                    selectedItem = selectedHour,
                    onItemSelected = { newHour ->
                        selectedHour = newHour
                        val hour24 = when {
                            selectedAMPM == "PM" && newHour != 12 -> newHour + 12
                            selectedAMPM == "AM" && newHour == 12 -> 0
                            else -> newHour
                        }
                        onTimeChanged(hour24, selectedMinute)
                    },
                    modifier = Modifier.weight(1f)
                )
                
                Text(
                    text = ":",
                    style = MaterialTheme.typography.displaySmall.copy(fontSize = 32.sp),
                    color = TextPrimary,
                    fontWeight = FontWeight.Bold,
                    modifier = Modifier.padding(horizontal = 8.dp)
                )
                
                // Minute picker - all 60 minutes for smooth selection
                WheelPicker(
                    items = (0..59).toList(),
                    selectedItem = selectedMinute,
                    onItemSelected = { newMinute ->
                        selectedMinute = newMinute
                        val hour24 = when {
                            selectedAMPM == "PM" && selectedHour != 12 -> selectedHour + 12
                            selectedAMPM == "AM" && selectedHour == 12 -> 0
                            else -> selectedHour
                        }
                        onTimeChanged(hour24, newMinute)
                    },
                    modifier = Modifier.weight(1f)
                )
                
                // AM/PM picker
                WheelPicker(
                    items = listOf("AM", "PM"),
                    selectedItem = selectedAMPM,
                    onItemSelected = { newAMPM ->
                        selectedAMPM = newAMPM
                        val hour24 = when {
                            newAMPM == "PM" && selectedHour != 12 -> selectedHour + 12
                            newAMPM == "AM" && selectedHour == 12 -> 0
                            else -> selectedHour
                        }
                        onTimeChanged(hour24, selectedMinute)
                    },
                    modifier = Modifier.weight(1f)
                )
            }
        }
    }
}

@Composable
fun <T> WheelPicker(
    items: List<T>,
    selectedItem: T,
    onItemSelected: (T) -> Unit,
    modifier: Modifier = Modifier
) {
    val listState = rememberLazyListState()
    val selectedIndex = items.indexOf(selectedItem).coerceAtLeast(0)
    val paddingItems = 10 // More padding for smoother infinite scroll feel
    val itemHeight = 48.dp
    
    // Scroll to selected item when it changes from outside
    LaunchedEffect(selectedItem) {
        if (selectedIndex >= 0 && selectedIndex < items.size) {
            delay(50)
            try {
                listState.animateScrollToItem(
                    index = selectedIndex + paddingItems,
                    scrollOffset = 0
                )
            } catch (e: Exception) {
                // Ignore scroll errors
            }
        }
    }
    
    // Initial scroll to selected item
    LaunchedEffect(Unit) {
        if (selectedIndex >= 0 && selectedIndex < items.size) {
            delay(200)
            try {
                listState.animateScrollToItem(
                    index = selectedIndex + paddingItems,
                    scrollOffset = 0
                )
            } catch (e: Exception) {
                // Ignore scroll errors
            }
        }
    }
    
    // Detect which item is in the center while scrolling - smooth detection
    val firstVisibleIndex = remember { 
        derivedStateOf { 
            listState.firstVisibleItemIndex 
        } 
    }
    
    val firstVisibleItemScrollOffset = remember {
        derivedStateOf {
            listState.firstVisibleItemScrollOffset
        }
    }
    
    // Track scroll state and update selection only when scroll stops
    LaunchedEffect(firstVisibleIndex.value, firstVisibleItemScrollOffset.value) {
        delay(500) // Wait for scroll to stop (debounce)
        val centerIndex = firstVisibleIndex.value - paddingItems
        if (centerIndex >= 0 && centerIndex < items.size) {
            val centerItem = items[centerIndex]
            val scrollOffset = firstVisibleItemScrollOffset.value
            // Only update if scroll offset is close to center (snapped)
            if (scrollOffset < 24 && centerItem != selectedItem) {
                onItemSelected(centerItem)
                // Ensure exact center alignment
                delay(200)
                try {
                    listState.animateScrollToItem(centerIndex + paddingItems, scrollOffset = 0)
                } catch (e: Exception) {
                    // Ignore
                }
            }
        }
    }
    
    Box(
        modifier = modifier
            .height(240.dp)
            .fillMaxWidth(),
        contentAlignment = Alignment.Center
    ) {
        // Highlight overlay for center item - more prominent
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .height(itemHeight)
                .background(
                    PrimaryLight.copy(alpha = 0.25f), 
                    RoundedCornerShape(10.dp)
                )
                .border(
                    width = 1.dp,
                    color = PrimaryLight.copy(alpha = 0.4f),
                    shape = RoundedCornerShape(10.dp)
                )
        )
        
        LazyColumn(
            state = listState,
            modifier = Modifier.fillMaxSize(),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.spacedBy(0.dp)
        ) {
            // Add padding items at top for infinite scroll feel
            items(paddingItems) {
                Spacer(modifier = Modifier.height(itemHeight))
            }
            
            items(items.size, key = { items[it].hashCode() }) { index ->
                val item = items[index]
                val isSelected = item == selectedItem
                val isCenter = (firstVisibleIndex.value - paddingItems) == index
                val scrollOffset = if (isCenter) firstVisibleItemScrollOffset.value else 0
                val isNearCenter = scrollOffset < 24
                
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(itemHeight)
                        .clickable {
                            onItemSelected(item)
                            // Immediately scroll to exact center when tapped
                            CoroutineScope(Dispatchers.Main).launch {
                                delay(50)
                                try {
                                    listState.animateScrollToItem(index + paddingItems, scrollOffset = 0)
                                } catch (e: Exception) {
                                    // Ignore
                                }
                            }
                        },
                    contentAlignment = Alignment.Center
                ) {
                    // Format minute with leading zero
                    val displayText = if (item is Int && items.size > 12) {
                        String.format("%02d", item)
                    } else {
                        item.toString()
                    }
                    
                    Text(
                        text = displayText,
                        style = MaterialTheme.typography.bodyLarge.copy(
                            fontSize = if (isSelected || (isCenter && isNearCenter)) 22.sp else 16.sp,
                            fontWeight = if (isSelected || (isCenter && isNearCenter)) FontWeight.Bold else FontWeight.Normal
                        ),
                        color = if (isSelected || (isCenter && isNearCenter)) {
                            TextPrimary
                        } else {
                            TextSecondary.copy(alpha = 0.5f)
                        }
                    )
                }
            }
            
            // Add padding items at bottom for infinite scroll feel
            items(paddingItems) {
                Spacer(modifier = Modifier.height(itemHeight))
            }
        }
    }
}

@Composable
fun TrustModeToggle(
    enabled: Boolean,
    onToggle: (Boolean) -> Unit,
    modifier: Modifier = Modifier
) {
    Row(
        modifier = modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(8.dp))
            .background(SurfaceDark.copy(alpha = 0.6f))
            .padding(16.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Row(
            modifier = Modifier.weight(1f),
            horizontalArrangement = Arrangement.spacedBy(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Box(
                modifier = Modifier
                    .size(48.dp)
                    .clip(RoundedCornerShape(8.dp))
                    .background(PrimaryLight.copy(alpha = 0.2f)),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = Icons.Default.VerifiedUser,
                    contentDescription = "Trust Mode",
                    tint = PrimaryLight,
                    modifier = Modifier.size(24.dp)
                )
            }
            
            Column {
                Text(
                    text = "Trust Mode",
                    style = MaterialTheme.typography.bodyLarge.copy(
                        fontWeight = FontWeight.Medium
                    ),
                    color = TextPrimary
                )
                
                Text(
                    text = "Hide your checklist and practice letting go.",
                    style = MaterialTheme.typography.bodyMedium.copy(
                        fontSize = 14.sp
                    ),
                    color = TextSecondary
                )
            }
        }
        
        Switch(
            checked = enabled,
            onCheckedChange = { newValue ->
                onToggle(newValue)
            },
            colors = SwitchDefaults.colors(
                checkedThumbColor = Color.White,
                checkedTrackColor = PrimaryLight,
                uncheckedThumbColor = Color.White,
                uncheckedTrackColor = Color.Black.copy(alpha = 0.2f)
            )
        )
    }
}

@Composable
fun CalmListItem(
    text: String,
    onDelete: () -> Unit,
    modifier: Modifier = Modifier
) {
    Row(
        modifier = modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(8.dp))
            .background(SurfaceDark.copy(alpha = 0.6f))
            .padding(16.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Text(
            text = text,
            style = MaterialTheme.typography.bodyLarge.copy(
                fontWeight = FontWeight.Medium
            ),
            color = TextPrimary,
            modifier = Modifier.weight(1f)
        )
        
        IconButton(onClick = onDelete) {
            Icon(
                imageVector = Icons.Default.Close,
                contentDescription = "Delete",
                tint = TextSecondary
            )
        }
    }
}

@Composable
fun AddItemInput(
    value: String,
    onValueChange: (String) -> Unit,
    onAdd: () -> Unit,
    modifier: Modifier = Modifier
) {
    Row(
        modifier = modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(8.dp))
            .background(SurfaceDark.copy(alpha = 0.6f))
            .padding(8.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        TextField(
            value = value,
            onValueChange = onValueChange,
            placeholder = {
                Text(
                    text = "Add item...",
                    color = TextSecondary
                )
            },
            colors = TextFieldDefaults.colors(
                focusedContainerColor = Color.Transparent,
                unfocusedContainerColor = Color.Transparent,
                disabledContainerColor = Color.Transparent,
                focusedTextColor = TextPrimary,
                unfocusedTextColor = TextPrimary,
                focusedIndicatorColor = Color.Transparent,
                unfocusedIndicatorColor = Color.Transparent,
                disabledIndicatorColor = Color.Transparent
            ),
            modifier = Modifier.weight(1f),
            singleLine = true
        )
        
        IconButton(
            onClick = onAdd,
            modifier = Modifier
                .size(36.dp)
                .clip(CircleShape)
                .background(PrimaryLight.copy(alpha = 0.2f))
        ) {
            Icon(
                imageVector = Icons.Default.Add,
                contentDescription = "Add",
                tint = PrimaryLight
            )
        }
    }
}
