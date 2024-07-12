
# Nubo IoT CLI

Nubo IoT CLI is a command-line tool to schedule and monitor IoT gateway jobs and download the resulting logs from AWS S3.

## Prerequisites

- Environment variable `API_TOKEN` set with the Nubo API token

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/nuboai/nubo-iot-cli.git
   cd nubo-iot-cli
   ```

2. Make the scripts executable:
   ```bash
   chmod +x cli.sh 
   ```

## Usage

### Scheduling Jobs

To schedule jobs for multiple IoT gateways and wait for their completion:

```bash
./cli.sh job_sched --wait <iot_gateway_id_1> <iot_gateway_id_2> ... <iot_gateway_id_n>
```

For example:
```bash
./cli.sh job_sched --wait 33102 32292
```

## Environment Variables

- `API_TOKEN`: The API token for authenticating with the Nubo API.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
