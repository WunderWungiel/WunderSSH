import subprocess
import tempfile

def run_session(binary, host, username, arguments, port=22, pubkey=None, password=None):

    binary, host, username, arguments = binary.strip(), host.strip(), username.strip(), arguments.strip()
    port = int(port)

    command = [binary, "-e"]

    ssh_command = f"ssh {username}@{host} -p {port}"

    for arg in arguments.split():
        ssh_command += f" {arg}"
    if pubkey:
        tmp = tempfile.NamedTemporaryFile(delete=False)
        tmp.write(pubkey.strip().encode("utf-8"))
        ssh_command += f"-i {tmp.name}"
    elif password:
        sshpass = f"/usr/share/harbour-wunderssh/bin/sshpass -p {password.strip()} "
        ssh_command = sshpass + ssh_command

    command.append(ssh_command)
    subprocess.Popen(command, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

