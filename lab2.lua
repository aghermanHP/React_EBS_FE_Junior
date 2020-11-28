----------------------------------------
-- script-name: watch_q50.lua
-- Q50 protocol dissector
--
-- author: Lupei Nicolae <nicolae.lupei@ee.utm.md>
-- Copyright (c) 2020, UTM
-- do not modify this table
local debug_level = {
    DISABLED = 0,
    LEVEL_1 = 1,
    LEVEL_2 = 2
}

-- a "enum" table for our enum pref, as required by Pref.enum()
-- having the "index" number makes ZERO sense, and is completely illogical
-- but it's what the code has expected it to be for a long time. Ugh.
local debug_pref_enum = {{1, "Disabled", debug_level.DISABLED}, {2, "Level 1", debug_level.LEVEL_1},
                         {3, "Level 2", debug_level.LEVEL_2}}

-- set this DEBUG to debug_level.LEVEL_1 to enable printing debug_level info
-- set it to debug_level.LEVEL_2 to enable really verbose printing
-- note: this will be overridden by user's preference settings
local DEBUG = debug_level.LEVEL_1

local default_settings = {
    port = 8005, -- default TCP port number for q50 watch
    debug_level = DEBUG
}

local dprint = function()
end
local dprint2 = function()
end
local function reset_debug_level()
    if default_settings.debug_level > debug_level.DISABLED then
        dprint = function(...)
            print(table.concat({"Lua:", ...}, " "))
        end

        if default_settings.debug_level > debug_level.LEVEL_1 then
            dprint2 = dprint
        end
    end
end
-- call it now
reset_debug_level()

dprint2("Wireshark version = ", get_version());
dprint2("Lua version = ", _VERSION);

q50_protocol = Proto("Q50", "Q50 watch PROTOCOL");

q50_protocol.prefs.debug = Pref.enum("Debug", default_settings.debug_level, "The debug printing level", debug_pref_enum);
q50_protocol.prefs.port = Pref.uint("Port number", default_settings.port, "The UDP port number for MyDNS");

-- =======================General data fields==================================
local packet_type_field = ProtoField.string("Packet.Type", "Type");
local packet_id_field = ProtoField.string("Packet.Id", "Id");
local packet_length_field = ProtoField.int32("Packet.PacketLength", "Packet Length");
local packet_data_field = ProtoField.string("Packet.RawData", "RawData");
local packet_company_name_field = ProtoField.string("Packet.CompanyName", "Company Name");
local packet_device_id_field = ProtoField.string("Packet.DeviceId", "Device Id");
local packet_content_length_field = ProtoField.string("Packet.ContentLength", "Content Length");

-- =====================Location Data fields===================================
local location_date_field = ProtoField.string("Location.Date", "Date");
local location_time_field = ProtoField.string("Location.Time", "Time");
local location_position_fieldunction_field = ProtoField.string("Location.PositionFonction", "Position Fonction");
local location_latitude_field = ProtoField.string("Location.Latitude", "Latitude");
local location_latitude_identification_field = ProtoField.string("Location.LatitudeIden", "Latitude Identification");
local location_longitude_field = ProtoField.string("Location.Longitude", "Longitude");
local location_longitude_identification_field = ProtoField.string("Location.LongitudeIden", "Longitude Identification");
local location_speed_field = ProtoField.string("Location.Speed", "Speed");
local location_direction_field = ProtoField.string("Location.Direction", "Direction");
local location_altitude_field = ProtoField.string("Location.Altitude", "Altitude");
local location_satellite_field = ProtoField.string("Location.Satellite", "Satellite");
local location_gsm_signal_strength_field = ProtoField.string("Location.GsmSignalStrength", "GSM signal strength");
local location_battery_field = ProtoField.string("Location.Battery", "Battery");
local location_pedometer_field = ProtoField.string("Location.Pedometer", "Pedometer");
local location_rolling_times_field = ProtoField.string("Location.RollingTimes", "Rolling Times");
local location_terminal_statement_field = ProtoField.string("Location.TerminalStatement", "Terminal Statement");
local location_base_station_number_field = ProtoField.string("Location.BaseStationNumber", "Base Station Number");
local location_connect_to_station_delay_field = ProtoField.string("Location.ConnectDelay", "Connect to station ta");
local location_mcc_country_code_field = ProtoField.string("Location.MCCCountryCode", "MCC country code");
local location_mnc_network_number_field = ProtoField.string("Location.MNCNetwork", "MNC network number");
local location_area_code_field = ProtoField.string("Location.AreaCode", "Area Code");
local location_serial_number_base_field = ProtoField.string("Location.SerialNumber",
                                              "Serial number to connect base station");
local location_signal_strength_field = ProtoField.string("Location.SignalStrength", "Signal Strength");

local location_nearby_station1_area_code_field = ProtoField.string("Location.NearbyStation1AreaCode",
                                                     "Station 1 serial code");
local location_nearby_station1_serial_number_field = ProtoField.string("Location.NearbyStation1SerialNumber",
                                                         "Station 1 serial number");
local location_nearby_station1_signal_strength_field = ProtoField.string("Location.NearbyStation1SignlaStrength",
                                                           "Station 1 signal strength");

local location_nearby_station2_area_code_field = ProtoField.string("Location.NearbyStation2AreaCode",
                                                     "Station 2 serial code");
local location_nearby_station2_serial_number_field = ProtoField.string("Location.NearbyStation2SerialNumber",
                                                         "Station 2 serial number");
local location_nearby_station2_signal_strength_field = ProtoField.string("Location.NearbyStation2SignlaStrength",
                                                           "Station 2 signal strength");

local location_nearby_station3_area_code_field = ProtoField.string("Location.NearbyStation3AreaCode",
                                                     "Station 3 serial code");
local location_nearby_station3_serial_number_field = ProtoField.string("Location.NearbyStation3SerialNumber",
                                                         "Station 3 serial number");
local location_nearby_station3_signal_strength_field = ProtoField.string("Location.NearbyStation3SignlaStrength",
                                                           "Station 3 signal strength");

-- =====================Link remains Data fields===================================
local lr_steps_field = ProtoField.string("LinkRemains.Steps", "Steps");
local lr_rolling_time_field = ProtoField.string("LinkRemains.RollingTimes", "Rolling Times");
local lr_battery_percentage_field = ProtoField.string("LinkRemains.BatteryPercentage", "Battery Percentage");

-- =====================Address requesting commands Data fields===================================
local adr_req_com_language_field = ProtoField.string("AddressRequestingCommands.Language", "Language");

q50_protocol.fields = {packet_type_field, packet_id_field, packet_length_field, packet_data_field, location_date_field,
                       location_time_field, location_position_fieldunction_field, location_latitude_field,
                       location_latitude_identification_field, location_longitude_field,
                       location_longitude_identification_field, location_speed_field, location_direction_field,
                       location_altitude_field, location_satellite_field, location_signal_strength_field,
                       location_battery_field, location_pedometer_field, location_rolling_times_field,
                       location_terminal_statement_field, location_base_station_number_field,
                       location_connect_to_station_delay_field, location_mcc_country_code_field,
                       location_mnc_network_number_field, location_area_code_field, location_serial_number_base_field,
                       location_gsm_signal_strength_field, location_nearby_station1_area_code_field,
                       location_nearby_station1_serial_number_field, location_nearby_station1_signal_strength_field,
                       location_nearby_station2_area_code_field, location_nearby_station2_serial_number_field,
                       location_nearby_station2_signal_strength_field, location_nearby_station3_area_code_field,
                       location_nearby_station3_serial_number_field, location_nearby_station3_signal_strength_field,
                       lr_steps_field, lr_rolling_time_field, lr_battery_percentage_field, adr_req_com_language_field,
                       packet_company_name_field, packet_device_id_field, packet_content_length_field};

function q50_protocol.dissector(buffer, pinfo, tree)
    print("=========Start to disect============");
    pinfo.cols.protocol = q50_protocol.name
    local length = buffer:len();
    print("Packet legth: " .. length);
    local subtree = tree:add(q50_protocol, buffer(), "Q50 PROTOCOL DATA")
    if (length == 0 or length == 1) then
        subtree:add(buffer(), "Missing data");
    else
        subtree:add(packet_length_field, length);
        local strData = buffer():string();
        subtree:add(packet_data_field, strData);
        print("Raw data: ", strData);
        if (strData:match("]%[")) then
            subtree:add(buffer(), "Cannot read truncated data");
        else
            local arr_data = Split(strData:sub(2, length - 1), ',');
            DisplayArray(arr_data);
            print("Header data", arr_data[1]);
            local headerArr = Split(arr_data[1], '*');
            DisplayArray(headerArr);
            -- company name
            subtree:add(packet_company_name_field, headerArr[1]);
            -- device id
            subtree:add(packet_device_id_field, headerArr[2]);
            -- content length
            subtree:add(packet_content_length_field, headerArr[3]);

            local packetId = headerArr[4];
            -- packet type
            subtree:add(packet_id_field, packetId);
            print("Id: ", packetId);

            local switch_packets = {
                ["LK"] = function(x)
                    subtree:add(packet_type_field, "Link remains");
                    WriteLinkRemainsData(subtree, buffer, arr_data);
                end,
                ["UD"] = function(x)
                    subtree:add(packet_type_field, "Location data reporting");
                    WriteLocationData(subtree, buffer, arr_data);
                end,
                ["UD2"] = function(x)
                    subtree:add(packet_type_field, "Blind spot data transmission");
                    WriteLocationData(subtree, buffer, arr_data);
                end,
                ["AL"] = function(x)
                    subtree:add(packet_type_field, "Alarming data reporting");
                    WriteLocationData(subtree, buffer, arr_data);
                end,
                ["WAD"] = function(x)
                    subtree:add(packet_type_field, "Address requesting commands");
                    WriteAddressRequestingData(subtree, buffer, arr_data);
                    WriteLocationData(subtree, buffer, arr_data:sub(3, arr_data:len()));
                end,
                ["WG"] = function(x)
                    subtree:add(packet_type_field, "Sending SMS");
                    WriteLocationData(subtree, buffer, arr_data);
                end,
                default = function(x)
                    print("Undefined terminal sending data!")
                end
            };

            Switch(switch_packets, packetId)
        end
    end
end

function WriteAddressRequestingData(subtree, buffer, data)
    local addressSubtree = subtree:add(q50_protocol, buffer(), "Address requesting commands data");
    addressSubtree:add(adr_req_com_language_field, data[2]);
end

function WriteLinkRemainsData(subtree, buffer, data)
    if (data[2] ~= nil) then
        local linkSubtree = subtree:add(q50_protocol, buffer(), "Link remains data");
        linkSubtree:add(lr_steps_field, data[2]);
        linkSubtree:add(lr_rolling_time_field, data[3]);
        linkSubtree:add(lr_battery_percentage_field, data[4] .. "%");
    end
end

function WriteLocationData(subtree, buffer, data) -- Write location data on tree
    local locationSubtree = subtree:add(q50_protocol, buffer(), "Location data");
    -- date
    locationSubtree:add(location_date_field, GetHumanDate(data[2]));
    -- time
    locationSubtree:add(location_time_field, string.format("%d hour %d minute %d seconds", data[3]:sub(1, 2),
        data[3]:sub(3, 4), data[3]:sub(5, 6)));
    -- position function
    if (data[3] == "A") then
        locationSubtree:add(location_position_fieldunction_field, "Position");
    else
        locationSubtree:add(location_position_fieldunction_field, "No Position");
    end

    -- latitude
    locationSubtree:add(location_latitude_field, data[5]);
    locationSubtree:add(location_latitude_identification_field, GetGeographicDirection(data[6]));
    -- longitude
    locationSubtree:add(location_longitude_field, data[7]);
    locationSubtree:add(location_longitude_identification_field, GetGeographicDirection(data[8]));
    -- speed
    locationSubtree:add(location_speed_field, data[9] .. " miles/hour");
    -- direction
    locationSubtree:add(location_direction_field, data[10] .. " degree");
    -- altitude
    locationSubtree:add(location_altitude_field, data[11] .. " meter");
    -- satellite
    locationSubtree:add(location_satellite_field, data[12]);
    -- GSM signal strength
    locationSubtree:add(location_gsm_signal_strength_field, data[13] .. " in range (0-100)");
    -- battery
    locationSubtree:add(location_battery_field, data[14] .. " %");
    -- pedometer
    locationSubtree:add(location_pedometer_field, data[15] .. " steps");
    -- rolling times
    locationSubtree:add(location_rolling_times_field, string.format("Rolling number is %d times", data[16]));
    -- terminal stetement
    locationSubtree:add(location_terminal_statement_field, data[17]);
    -- base station number
    locationSubtree:add(location_base_station_number_field, data[18]);
    -- gsm time delay
    locationSubtree:add(location_connect_to_station_delay_field, data[19]);
    -- mcc country code
    locationSubtree:add(location_mcc_country_code_field, data[20]);
    -- mnc netwotk number
    locationSubtree:add(location_mnc_network_number_field, data[21]);
    -- base area code
    locationSubtree:add(location_area_code_field, data[22]);
    -- base station serial code
    locationSubtree:add(location_base_station_number_field, data[23]);
    -- base signal strength
    locationSubtree:add(location_signal_strength_field, data[24]);
    -- nearby station 1 area code
    locationSubtree:add(location_nearby_station1_area_code_field, data[25]);
    -- nearby station 1 serial number
    locationSubtree:add(location_nearby_station1_serial_number_field, data[26]);
    -- nearby station 1 signal strength
    locationSubtree:add(location_nearby_station1_signal_strength_field, data[27]);

    -- nearby station 2 area code
    locationSubtree:add(location_nearby_station2_area_code_field, data[28]);
    -- nearby station 2 serial number
    locationSubtree:add(location_nearby_station2_serial_number_field, data[29]);
    -- nearby station 2 signal strength
    locationSubtree:add(location_nearby_station2_signal_strength_field, data[30]);

    -- nearby station 3 area code
    locationSubtree:add(location_nearby_station3_area_code_field, data[31]);
    -- nearby station 3 serial number
    locationSubtree:add(location_nearby_station3_serial_number_field, data[32]);
    -- nearby station 3 signal strength
    locationSubtree:add(location_nearby_station3_signal_strength_field, data[33]);
end

-- ======================Helpers=======================

function GetHumanDate(date)
    return "20" .. date:sub(5, 6) .. " year " .. date:sub(3, 4) .. " month " .. date:sub(1, 2) .. " day";
end

function DisplayArray(arr)
    for k, v in pairs(arr) do
        print(string.format("arr[%d]=", k), v);
    end
end

function Switch(statement, input)
    if statement[input] ~= nil then
        return statement[input]();
    else
        return statement.default();
    end
end

function Split(pString, pPattern)
    local Table = {}
    local fpat = "(.-)" .. pPattern
    local last_end = 1
    local s, e, cap = pString:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(Table, cap)
        end
        last_end = e + 1
        s, e, cap = pString:find(fpat, last_end)
    end
    if last_end <= #pString then
        cap = pString:sub(last_end)
        table.insert(Table, cap)
    end
    return Table
end

function GetGeographicDirection(symbol)
    local switch_rules = {
        ["E"] = function(x)
            return "E (East)";
        end,
        ["W"] = function(x)
            return "W (West)";
        end,
        ["N"] = function(x)
            return "N (North)";
        end,
        ["S"] = function(x)
            return "S (South)";
        end,
        default = function(x)
            return "Undefined!";
        end
    };
    return Switch(switch_rules, symbol);
end

-- ======================Wireshark filters=========================
tcp_table = DissectorTable.get("tcp.port")
tcp_table:add(default_settings.port, q50_protocol)
