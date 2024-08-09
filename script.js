function setReminder() {
    const day = document.getElementById('day').value;
    const time = document.getElementById('time').value;
    const activity = document.getElementById('activity').value;

    if (!time) {
        alert('Please select a time.');
        return;
    }

    const reminderTime = new Date();
    const [hours, minutes] = time.split(':').map(Number);
    reminderTime.setHours(hours);
    reminderTime.setMinutes(minutes);
    reminderTime.setSeconds(0);

    const now = new Date();
    // If the reminder time is earlier in the day than the current time, set it to the next day
    if (reminderTime <= now) {
        reminderTime.setDate(reminderTime.getDate() + 1);
    }

    const timeDifference = reminderTime - now;

    setTimeout(() => {
        alert(`Reminder: ${activity} on ${day}`);
        // Play a sound
        playSound();
    }, timeDifference);
}

function playSound() {
    const audio = new Audio('C:\Users\my\Desktop\intern\All\flutter\alaram.wpv'); // Use a relative path or URL for the audio file
    audio.play().catch(error => {
        console.error('Error playing sound:', error);
    });
}
