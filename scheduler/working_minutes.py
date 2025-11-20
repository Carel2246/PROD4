from datetime import datetime, timedelta, time
import psycopg2

def load_working_hours(db_config):
    conn = psycopg2.connect(**db_config)
    cur = conn.cursor()
    cur.execute("SELECT weekday, start_time, end_time FROM calendar")
    calendar = {}
    for weekday, start, end in cur.fetchall():
        calendar[weekday] = (start, end)
    cur.close()
    conn.close()
    return calendar

def minute_to_datetime(start_date, minute, calendar):
    """
    start_date: datetime.date (first day to schedule)
    minute: int (schedule minute, starting at 1)
    calendar: dict {weekday: (start_time, end_time)}
    Returns: datetime.datetime
    """
    current_date = start_date
    minutes_left = minute
    while True:
        weekday = current_date.weekday()  # Monday=0
        if weekday in calendar:
            start_t, end_t = calendar[weekday]
            start_dt = datetime.combine(current_date, start_t)
            end_dt = datetime.combine(current_date, end_t)
            work_minutes = int((end_dt - start_dt).total_seconds() // 60)
            if minutes_left <= work_minutes:
                return start_dt + timedelta(minutes=minutes_left)
            else:
                minutes_left -= work_minutes
        # Move to next day
        current_date += timedelta(days=1)

def convert_schedule_minutes_to_datetimes(schedule, start_date, calendar):
    """
    Converts schedule minute fields to datetime fields.
    schedule: list of dicts with 'start_minute' and 'end_minute'
    start_date: datetime.date
    calendar: dict {weekday: (start_time, end_time)}
    Returns: list of dicts with added 'start_datetime' and 'end_datetime'
    """
    result = []
    for item in schedule:
        start_dt = minute_to_datetime(start_date, item["start_minute"], calendar)
        end_dt = minute_to_datetime(start_date, item["end_minute"], calendar)
        new_item = item.copy()
        new_item["start_datetime"] = start_dt
        new_item["end_datetime"] = end_dt
        result.append(new_item)
    return result

# Example usage:
# db_config = {...}
# calendar = load_working_hours(db_config)
# dt = minute_to_datetime(datetime(2025,8,7).date(), 541, calendar)
# print(dt)  # Should print 2025-08-08 07:01:00
