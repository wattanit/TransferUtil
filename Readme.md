# Transfer Utility

Script to transfer large file from local to a remote server.

## Usage

```
./transferUtil.sh <remote_host> <file_path>
```

remote_host should be in the ssh format: username@hostname.

## Recommendation

It is recommended to set up ssh using RSA keys to avoid multiple password entries. 
Follow this tutorial to set up RSA access if you have already done so: https://www.thegeekstuff.com/2008/11/3-steps-to-perform-ssh-login-without-password-using-ssh-keygen-ssh-copy-id .
