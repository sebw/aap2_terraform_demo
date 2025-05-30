# infra.aap_configuration.hub_namespace

## Description

An Ansible Role to create Namespaces in Automation Hub.

## Variables

|Variable Name|Default Value|Required|Description|Example|
|:---:|:---:|:---:|:---:|:---:|
|`aap_hostname`|""|yes|URL to the Ansible Automation Platform Server.|127.0.0.1|
|`aap_username`|""|no|Admin User on the Ansible Automation Platform Server. Either username / password or oauthtoken need to be specified.||
|`aap_password`|""|no|Platform Admin User's password on the Server.  This should be stored in an Ansible Vault at vars/platform-secrets.yml or elsewhere and called from a parent playbook.||
|`ah_token`|""|yes|Tower Admin User's token on the Automation Hub Server.  This should be stored in an Ansible Vault at or elsewhere and called from a parent playbook.||
|`aap_validate_certs`|`true`|no|Whether or not to validate the Ansible Automation Platform Server's SSL certificate.||
|`aap_request_timeout`|`10`|no|Specify the timeout Ansible should use in requests to the Galaxy or Automation Hub host.||
|`ah_path_prefix`|""|no|API path used to access the api. Either galaxy, automation-hub, or custom||
|`aap_configuration_async_dir`|`null`|no|Sets the directory to write the results file for async tasks. The default value is set to `null` which uses the Ansible Default of `/root/.ansible_async/`.||
|`hub_namespaces`|`see below`|yes|Data structure describing your namespaces, described below.||

### Secure Logging Variables

The following Variables compliment each other.
If Both variables are not set, secure logging defaults to false.
The role defaults to false as normally the add namespace task does not include sensitive information.
hub_configuration_namespace_secure_logging defaults to the value of aap_configuration_secure_logging if it is not explicitly called. This allows for secure logging to be toggled for the entire suite of automation hub configuration roles with a single variable, or for the user to selectively use it.

|Variable Name|Default Value|Required|Description|
|:---:|:---:|:---:|:---:|
|`hub_configuration_namespace_secure_logging`|`false`|no|Whether or not to include the sensitive Namespace role tasks in the log.  Set this value to `true` if you will be providing your sensitive values from elsewhere.|
|`aap_configuration_secure_logging`|`false`|no|This variable enables secure logging as well, but is shared across multiple roles, see above.|

### Asynchronous Retry Variables

The following Variables set asynchronous retries for the role.
If neither of the retries or delay or retries are set, they will default to their respective defaults.
This allows for all items to be created, then checked that the task finishes successfully.
This also speeds up the overall role.

|Variable Name|Default Value|Required|Description|
|:---:|:---:|:---:|:---:|
|`aap_configuration_async_timeout`|1000|no|This variable sets the async timeout for the role globally.|
|`hub_configuration_namespace_async_timeout`|`aap_configuration_async_timeout`|no|This variable sets the async timeout for the role.|
|`aap_configuration_async_retries`|50|no|This variable sets the number of retries to attempt for the role globally.|
|`hub_configuration_namespace_async_retries`|`aap_configuration_async_retries`|no|This variable sets the number of retries to attempt for the role.|
|`aap_configuration_loop_delay`|1000|no|This variable sets the loop_delay for the role globally.|
|`hub_configuration_namespace_loop_delay`|`aap_configuration_loop_delay`|no|This variable sets the loop_delay for the role.|
|`aap_configuration_async_delay`|1|no|This sets the delay between retries for the role globally.|
|`hub_configuration_namespace_async_delay`|`aap_configuration_async_delay`|no|This sets the delay between retries for the role.|

## Data Structure

### Namespace Variables

|Variable Name|Default Value|Required|Type|Description|
|:---:|:---:|:---:|:---:|:---:|
|`name`|""|yes|str|Namespace name. Must be lower case containing only alphanumeric characters and underscores.|
|`new_name`|""|yes|str|Setting this option will change the existing name (looked up via the name field.)|
|`description`|""|yes|str|Description to use for the Namespace.|
|`company`|""|no|str|Namespace owner company name.|
|`email`|"password"|yes|str|Namespace contact email.|
|`avatar_url`|"public"|yes|str|Namespace logo URL.|
|`resources`|""|no|str|Namespace resource page in Markdown format.|
|`links`|[]|no|list|A list of dictionaries of Name and url values for links related the Namespace. See below for details.|
|`groups`|[]|yes|list|A list of dictionaries of the Names of groups that own the Namespace.|
|`state`|`present`|no|str|Desired state of the namespace.|

#### Links

|Variable Name|Default Value|Required|Type|Description|
|:---:|:---:|:---:|:---:|:---:|
|`name`|""|yes|str|Link Text.|
|`description`|""|yes|str|Link URL.|

### Standard Project Data Structure

#### Yaml Example

```yaml
---
hub_namespaces:
  - name: abc15
    company: Redhat
    email: user@example.com
    avatar_url: https://static.redhat.com/libs/redhat/brand-assets/latest/corp/logo.svg
    description: string
    resources: "# Redhat\nA Namespace test with changes"
    links:
      - name: "New_Google"
        url: "http://www.google.com"
    groups:
      # For groups that participate in an organization for example, system organization
      - system::partner-engineers
      # For groups without organizations
      - team
```

## Playbook Examples

### Standard Role Usage

```yaml
---
- name: Add namespace to Automation Hub
  hosts: localhost
  connection: local
  gather_facts: false
  vars:
    aap_validate_certs: false
  # Define following vars here, or in ah_configs/ah_auth.yml
  # ah_host: ansible-ah-web-svc-test-project.example.com
  # ah_token: changeme
  pre_tasks:
    - name: Include vars from ah_configs directory
      ansible.builtin.include_vars:
        dir: ./vars
        extensions: ["yml"]
      tags:
        - always
  roles:
    - infra.aap_configuration.hub_namespace
```

## License

[GPLv3+](https://github.com/ansible/galaxy_collection#licensing)

## Author

[Sean Sullivan](https://github.com/sean-m-sullivan/)
