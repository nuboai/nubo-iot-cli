#!/bin/bash

# Load the library of functions
source "$(dirname "$0")/api_functions"

# Check if the API token environment variable is set
if [ -z "$API_TOKEN" ]; then
  echo "Error: API_TOKEN environment variable is not set."
  exit 1
fi

# Check if at least one command is passed
if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <command> [options]"
  echo "Commands:"
  echo "  job_sched [--wait] <iot_gateway_id_1> <iot_gateway_id_2> ... <iot_gateway_id_n>"
  echo "  job_get <job_id>"
  exit 1
fi

# Main script logic
command=$1
shift

case $command in
  job_sched)
    # Check for the --wait parameter
    wait_for_completion=false
    while [[ "$1" == --* ]]; do
      case "$1" in
        --wait)
          wait_for_completion=true
          ;;
      esac
      shift
    done

    # Check if at least one iot_gateway_id is provided
    if [ "$#" -lt 1 ]; then
      echo "Usage: $0 job_sched [--wait] <iot_gateway_id_1> <iot_gateway_id_2> ... <iot_gateway_id_n>"
      exit 1
    fi

    # Get the iot_gateway_ids
    iot_gateway_ids=("$@")

    # Call the function to schedule the jobs
    job_ids=()
    for iot_gateway_id in "${iot_gateway_ids[@]}"; do
      job_id=$(job_sched "$iot_gateway_id")
      job_ids+=("$job_id")
    done

    # If wait_for_completion is true, wait for the jobs to complete
    if [ "$wait_for_completion" = true ]; then
      for job_id in "${job_ids[@]}"; do
        while true; do
          status_response=$(job_get "$job_id")

          status=$(echo "$status_response" | jq -r '.status')

          if [ "$status" = "COMPLETED" ] || [ "$status" = "FAILED" ] || [ "$status" = "CANCELED" ]; then
            echo "$status_response"
            break
          fi
          sleep 5
        done
      done
    else
      echo "${job_ids[@]}" # Print the job IDs if not waiting
    fi
    ;;

  job_get)
    if [ "$#" -lt 1 ]; then
      echo "Usage: $0 job_get <job_id>"
      exit 1
    fi
    job_id=$1
    job_get "$job_id"
    ;;

  *)
    echo "Unknown command: $command"
    echo "Usage: $0 <command> [options]"
    echo "Commands:"
    echo "  job_sched [--wait] <iot_gateway_id_1> <iot_gateway_id_2> ... <iot_gateway_id_n>"
    echo "  job_get <job_id>"
    exit 1
    ;;
esac
