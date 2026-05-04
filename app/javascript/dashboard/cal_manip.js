function CreateCalendarEvent() {
    const container = document.getElementById("cal_creators");
    if (!container) {
        alert("Could not find 'cal_creators' div")
        return;
    }
    const fromDate = getValById("cal_manip_from_date_picker")
    const fromTime = getValById("cal_manip_fromTime")
    const toTime = getValById("cal_manip_toTime")
    const subjectRaw = getValById("cal_manip_subject")
    const subject = encodeURIComponent(subjectRaw)
    const notes = encodeURIComponent(getValById("cal_manip_notes"))
    const allDay = document.getElementById("cal_manip_all_day").checked
    const fromDateTime = createDateTime(fromDate, fromTime)
    const toDateTime = createDateTime(fromDate, toTime)
    if (!allDay && !isFromBeforeTo(fromTime, toTime)) {
        alert("From Time must be before To Time")
        return
    }
    if (fromDate === "") {
        alert("Date is mandatory")
        return
    }
    console.log(">>> getValById cal_man_all_day returned",document.getElementById("cal_manip_all_day"))
    showSpinner()
    window.location.href = `/create_event?title=${subject}&st=${fromDateTime}&et=${toDateTime}&desc=${notes}&allday=${allDay}`
    // >>> const linkText = `${fromDate} ${fromTime}-${toTime} ${subjectRaw}`
    //addCreatorLink(container, "https://calendar.yahoo.com/?v=60&view=m&type=20&title=With Button&st=20260211T100000Z&et=20260211T103000Z&desc=Bazinga Florence", "with button")
    // >>> addCreatorLink(container, `https://calendar.yahoo.com/?v=60&view=m&type=20&title=${subject}&st=${fromDateTime}&et=${toDateTime}&desc=${notes}`, linkText)
}

function getValById(thisId) {
    const elem = document.getElementById(thisId)
    if (elem) {
        return elem.value
    } else {
        console.log(`Warning: could not find element with id ${thisId}`)
        return ""
    }
}

function createDateTime(dateVal, timeVal) {
    // Parse date
    const [day, month, yearShort] = dateVal.split("/").map(Number);
    const [hour, minute] = timeVal.split(":").map(Number);

    // Convert 2-digit year (assume 2000–2099)
    const year = 2000 + yearShort;

    // Create local date
    const localDate = new Date(year, month - 1, day, hour, minute, 0);

    // Convert to UTC components
    const yyyy = localDate.getUTCFullYear();
    const mm = String(localDate.getUTCMonth() + 1).padStart(2, "0");
    const dd = String(localDate.getUTCDate()).padStart(2, "0");
    const hh = String(localDate.getUTCHours()).padStart(2, "0");
    const min = String(localDate.getUTCMinutes()).padStart(2, "0");

    return `${yyyy}${mm}${dd}T${hh}${min}00Z`;
}

function addCreatorLink(container, url, description) {
    /* NO LONGER IN USE - WAS PART OF YAHOO */
    if (!container) return;

    // Create wrapper
    const wrapper = document.createElement("div");

    // Create link
    const link = document.createElement("a");
    link.href = url;
    link.textContent = description;
    link.target = "_blank";
    link.rel = "noopener noreferrer";
    link.addEventListener("click", function (e) {
      e.preventDefault();
      window.open(url, "_blank", "popup,width=800,height=600");
    });

    // Create delete button
    const btn = document.createElement("button");
    btn.textContent = "x";
    btn.type = "button";
    btn.addEventListener("click", function () {
        deleteCreatorLink(this);
    });

    // Assemble
    wrapper.appendChild(link);
    wrapper.appendChild(document.createTextNode(" "));
    wrapper.appendChild(btn);

    // Insert at top of container
    if (container.firstChild) {
        container.insertBefore(wrapper, container.firstChild);
    } else {
        container.appendChild(wrapper);
    }
}

function deleteCreatorLink(button) {
    /* NO LONGER IN USE - WAS PART OF YAHOO */
    if (!button) return;
    const wrapper = button.parentElement;
    if (wrapper) {
        wrapper.remove();
    }
}

function calDateClicked(calField) {
    // Deprecated - do not duplicate this instead use: field_utils.turn_on_datefield
    setTimeout(() => {
      turnOnField(calField, 'cal_manip_from_date', 'cal_manip_from_date_parent', 'cal_manip_from_date_picker', true)
    }, 500);
}

function calAllDayClicked(allDay) {
    console.log(`>>> value is: ${allDay.checked}`)
    const elements = document.querySelectorAll(".notallday");
    console.log(">>> elements = ", elements)

    elements.forEach(function(el) {
        if (allDay.checked) {
            el.classList.add('hidden_but_takes_space');
        } else {
            el.classList.remove('hidden_but_takes_space');
        }
        console.log(">>> after change = ", el)
    });
}

function closeToast() {
    removeClass('toast', 'notice_level_info')
    removeClass('toast', 'notice_level_error')
    makeInvisible('toast')
}

function isFromBeforeTo(fromVal, toVal) {
    if (!fromVal || !toVal) return false; // handle empty values

    const [fh, fm] = fromVal.split(":").map(Number);
    const [th, tm] = toVal.split(":").map(Number);

    const fromMinutes = fh * 60 + fm;
    const toMinutes = th * 60 + tm;

    return fromMinutes < toMinutes;
}