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

function updateHaStatus(status, text, moreText, prefix) {
    document.getElementById(`${prefix}_ok`).classList.add('hidden')
    document.getElementById(`${prefix}_ko`).classList.add('hidden')
    document.getElementById(`${prefix}_working`).classList.add('hidden')
    const ballStatus = (status == 'ok' || status === 'working' || status === 'ko') ? status : 'ko'
    document.getElementById(`${prefix}_${ballStatus}`).classList.remove('hidden')
    document.getElementById(`${prefix}_text`).innerText = text
    const now = new Date().toLocaleString('en-GB', {
      dateStyle: 'short',
      timeStyle: 'medium'
    });
    document.getElementById(`${prefix}_text`).dataset.tooltip = `${text}\n${moreText}\n\nLast Update: ${now}`
}

function showHealthStatusDets(element) {
    alert(element.dataset.tooltip)
}

document.addEventListener('DOMContentLoaded', function() {``
    function checkHomeAssistantStatus() {
      updateHaStatus('working', '', '', 'ha_health')
      updateHaStatus('working', '', '', 'smart_health')
      fetch('/home_assistant_status/last')
        .then(response => {
          if (!response.ok) {
            updateHaStatus('ko', 'HTTP ERROR', '', 'ha_health')
            updateHaStatus('ko', `${response.status}`, '', 'smart_health')
          }
          return response.json();
        })
        .then(data => {
          updateHaStatus(data.status, data.status_message, '', 'ha_health')
          updateHaStatus(data.smart_home_status, data.connected_message, data.disconnected_message, 'smart_health')
        })
        .catch(error => {
          updateHaStatus('ko', 'Error getting HA Status', '', 'ha_health')
          updateHaStatus('ko', error, '', 'smart_health')
        });
    }
    
    // Check immediately when the page loads
    checkHomeAssistantStatus();
    // Then check every 5 minutes
    //setInterval(checkHomeAssistantStatus, 5 * 60 * 1000);
    setInterval(checkHomeAssistantStatus, 30000);
});    


// Schedule the refresh when the page loads
window.onload = scheduleRefresh;
