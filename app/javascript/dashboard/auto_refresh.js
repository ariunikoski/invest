function scheduleRefresh() {
    // Function to check the time and refresh the page if within the specified range
    function refreshPage() {
        const now = new Date();
        const currentHour = now.getHours();
        
        // Refresh if the current time is between 06:00 and 22:00 (inclusive)
        if (currentHour >= 6 && currentHour <= 22) {
            window.location.reload();
        }
    }

    // Call the refreshPage function immediately to check and refresh if needed
    // refreshPage();

    // Set an interval to call the refreshPage function every hour (3600000 milliseconds)
    setInterval(refreshPage, 3600000);
    // setInterval(refreshPage, 60000);
}

function refreshClicked() {
    window.location.reload()
}

function scroll_to(to_here) {
    refreshWithArg('scroll_to', to_here)
}

function refreshWithArg(key, value) {
    const url = new URL(window.location.href);
    url.searchParams.set(key, value);
    window.location.href = url.toString();
}

// Schedule the refresh when the page loads
window.onload = scheduleRefresh;
