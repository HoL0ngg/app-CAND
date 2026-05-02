package com.cand.backend.enums;

public enum NotificationRecipientType {
    SAME_UNIT("Cùng đơn vị"),
    SUBORDINATE_UNITS("Đơn vị cấp dưới"),
    BOTH("Cùng đơn vị và cấp dưới");

    private final String displayName;

    NotificationRecipientType(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}
