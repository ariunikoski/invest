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
    refreshWithArgs({
        scroll_to: to_here,
        notice: null,
        notice_level: null
    })
}

function refreshWithArgs(args) {
    const url = new URL(window.location.href);

    // Support:
    // 1. Object: { name: value }
    // 2. Array: [ [name, value], ... ]
    // 3. Map

    let pairs = [];

    if (args instanceof Map) {
        pairs = Array.from(args.entries());
    } else if (Array.isArray(args)) {
        pairs = args;
    } else if (args && typeof args === "object") {
        pairs = Object.entries(args);
    }

    for (const [name, value] of pairs) {
        if (value === null) {
            url.searchParams.delete(name);
        } else {
            url.searchParams.set(name, value);
        }
    }

    window.location.href = url.toString();
}
// Schedule the refresh when the page loads
window.onload = scheduleRefresh;
