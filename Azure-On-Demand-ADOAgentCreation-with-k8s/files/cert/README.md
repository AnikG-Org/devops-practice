# PwC Certification Authority for Python

Add PwC certification authority to verify the PwC servers fingerprint.

**Usage:**
```bash
python ./addbundle.py
```

**Example usage in Dockerfile:**
```Dockerfile
ARG GITHUB_USERNAME
ARG GITHUB_PASSWORD

RUN git clone https://${GITHUB_USERNAME}:${GITHUB_PASSWORD}@github.pwc.com/AI-Lab/pwc-cert-authority.git /tmp/pwc-cert-authority
WORKDIR /tmp/pwc-cert-authority
RUN python addbundle.py
```
