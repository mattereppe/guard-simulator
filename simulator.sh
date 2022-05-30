#!/bin/bash

MAX_DEPARTMENTS=4
max_delay=4             # Max delay beetween requests
users=1
departments=1
dep0_url=https://guard-test-department-1.maggiolicloud.it
dep0_username="tester"
dep0_password="GuardH2020tester!"
#dep1_url=http://localhost:8080
#dep2_url=http://localhost:8080
#dep3_url=http://localhost:8080
declare -a listOfPatients=("121bfad0-0353-4bbe-80b9-99039ff6bcef" "154e9ee7-eb09-4530-bd64-ce47453c7328")


usage()
{
    echo "usage: simulator [[[-d departments ] [-u users] [-d max-delay]] | [-h]]"
}

authenticateUser()
{
    dep_url=$1;
    echo "URL: $dep_url"
    username=$dep0_username;
    password=$dep0_password;

    echo "Authenticate user ${username}";
    token=$(curl -s --location --request POST "${dep_url}/api/authenticate" \
                        --header "Content-Type: application/json" \
                        --data-raw "{
                            \"username\": \"${username}\",
                            \"password\": \"${password}\",
                            \"rememberMe\": true
                        }" \
            | jq -r '.id_token');
    echo "Token: $token";

    echo "Get Authenticate of user: ${username}";
    echo "HTTP Status: $(curl -s -o /dev/null --write-out '%{http_code}' --location --request GET "${dep_url}/api/authenticate")";
    echo "";

    echo "Get Account of user: ${username}";
    echo "HTTP Status: $(curl -s -o /dev/null --write-out '%{http_code}' --location --request GET "${dep_url}/api/account" --header "Authorization: Bearer ${token}")";
    echo "";
}

navigatePatientData()
{
    local id=$1;
    echo "Get Datails of patient ${id}";
    echo "HTTP Status: $(curl -s -o /dev/null --write-out '%{http_code}' --location --request GET "${dep_url}/api/patient/${id}" --header "Authorization: Bearer ${token}")";
    echo "";
    echo "Get Medical Records of patient ${id}";
    echo "HTTP Status: $(curl -s -o /dev/null --write-out '%{http_code}' --location --request GET "${dep_url}/api/patient/${id}/mhr" --header "Authorization: Bearer ${token}")";
    echo "";
    sleep $(( $RANDOM % $max_delay ));

    local medicalRecordId="509d391b-92ef-4bd0-9604-77c62e207aef";
    echo "Get Details of Medical Record ${medicalRecordId}";
    echo "HTTP Status: $(curl -s -o /dev/null --write-out '%{http_code}' --location --request GET "${dep_url}/api/mhr/${medicalRecordId}" --header "Authorization: Bearer ${token}")";
    echo "";
    echo "Get Series of Medical Record ${medicalRecordId}";
    echo "HTTP Status: $(curl -s -o /dev/null --write-out '%{http_code}' --location --request GET "${dep_url}/api/mhr/${medicalRecordId}/series" --header "Authorization: Bearer ${token}")";
    echo "";
    sleep $(( $RANDOM % $max_delay ));

    local medicalSerieId="c8133007-c41a-43b2-a719-c36e533a17d5";
    echo "Get Detail of serie ${medicalSerieId}";
    echo "HTTP Status: $(curl -s -o /dev/null --write-out '%{http_code}' --location --request GET "${dep_url}/api/serie/${medicalSerieId}" --header "Authorization: Bearer ${token}")";
    echo "";
    echo "Get Instances of Medical Serie ${medicalSerieId}";
    echo "HTTP Status: $(curl -s -o /dev/null --write-out '%{http_code}' --location --request GET "${dep_url}/api/serie/${medicalSerieId}" --header "Authorization: Bearer ${token}")";
    echo "";
    sleep $(( $RANDOM % $max_delay ));

    echo "Get Details of Medical Record ${medicalRecordId}";
    echo "HTTP Status: $(curl -s -o /dev/null --write-out '%{http_code}' --location --request GET "${dep_url}/api/mhr/${medicalRecordId}" --header "Authorization: Bearer ${token}")";
    echo "";
    echo "Get Reports of Medical Record ${medicalRecordId}";
    echo "HTTP Status: $(curl -s -o /dev/null --write-out '%{http_code}' --location --request GET "${dep_url}/api/mhr/${medicalRecordId}/reports" --header "Authorization: Bearer ${token}")";
    echo "";

    local medicalReportId="1006";
    sleep $(( $RANDOM % $max_delay ));
    echo "Download medical report ${medicalReportId}";
    echo "HTTP Status: $(curl -s -o /dev/null --write-out '%{http_code}' --location --request GET "${dep_url}/api/report/${medicalReportId}/download" --header "Authorization: Bearer ${token}")";
    echo "";
    sleep $(( $RANDOM % $max_delay ));
}

getListOfPatients()
{
#    echo "Get List of patient ${id}";
    echo "HTTP Status: $(curl -s -o /dev/null --write-out '%{http_code}' --location --request GET "${dep_url}/api/patient" --header "Authorization: Bearer ${token}")";
    echo "";
    sleep $(( $RANDOM % $max_delay ));
#    local username="TEST01";
    for userid in "${listOfPatients[@]}"
    do
        echo "START NAVIGATION PATIENT DATA OF: ${userid}";
        echo "";
        navigatePatientData "$userid";
        echo "END NAVIGATION PATIENT DATA OF: ${userid}";
        echo "";
    done
}

simulateUserSession()
{
    sleep $(( $RANDOM % $max_delay ));
    echo "Username $u for department $d";
    sleep $(( $RANDOM % $max_delay ));
    authenticateUser $dep0_url;
    sleep $(( $RANDOM % $max_delay ));
    getListOfPatients $dep0_url;
}

simulateDepartment()
{
    u=0;
    while [ $u -lt $users ]
    do
        simulateUserSession &
        u=$((u + 1));
    done
    wait
    echo "Simulated All User of department $d";
}

runSimulation()
{
#    d=0;
#    while [ $d -lt $departments ]
#    do
#        simulateDepartment &
#        d=$((d + 1));
#    done
#    wait
    simulateDepartment
    echo "Simulated All data for Department $dep0_url";
}

while [ "$1" != "" ]; do
    case $1 in
#        -d | --departments )    shift
#                                departments="$1"
#                                ;;
        -u | --users )          shift
                                users="$1"
                                ;;
        -d | --max-delay )      shift
                                max_delay="$1"
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done
# Test code to verify command line processing

#if [ "$departments" -gt $MAX_DEPARTMENTS ]
#then
#  echo "Max number of departments is $MAX_DEPARTMENTS";
#  departments=$MAX_DEPARTMENTS;
#fi
echo "Number of departments to simulate = $departments";
echo "Number of users to simulate = $users";
runSimulation;

