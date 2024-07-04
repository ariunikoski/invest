function scheduleRefresh() {
    // Function to check the time and refresh the page if within the specified range
    function refreshPage() {
		console.log('>>> entered refresh page')
        const now = new Date();
        const currentHour = now.getHours();
        
        // Refresh if the current time is between 06:00 and 22:00 (inclusive)
        if (currentHour >= 6 && currentHour <= 22) {
            console.log('>>> going to reload')
            window.location.reload();
        }
    }

    // Call the refreshPage function immediately to check and refresh if needed
    console.log('>>> caling refreshg')
    // refreshPage();

    // Set an interval to call the refreshPage function every hour (3600000 milliseconds)
    setInterval(refreshPage, 3600000);
    // setInterval(refreshPage, 60000);
}

console.log('>>> setting onload')
// Schedule the refresh when the page loads
window.onload = scheduleRefresh;
