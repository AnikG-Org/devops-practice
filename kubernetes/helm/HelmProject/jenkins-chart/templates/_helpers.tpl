{{/*
Expand the name of the chart.
*/}}
{{- define "jenkins-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "jenkins-chart.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "jenkins-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "jenkins-chart.labels" -}}
helm.sh/chart: {{ include "jenkins-chart.chart" . }}
app.kubernetes.io/maintainers-name: {{ .Values.maintainer | lower }}
Env: {{ .Values.Env }}
{{ include "jenkins-chart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "jenkins-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "jenkins-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "jenkins-chart.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "jenkins-chart.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* {{ .Values.deployment.namespace }}
Create the name of the namespace to use
*/}}
{{- define "jenkins-chart.namespace" -}}
{{- if .Values.deployment.namespace.create }}
{{- default (include "jenkins-chart.fullname" .) .Values.deployment.namespace.name }}
{{- else }}
{{- default "default" .Values.deployment.namespace.name }}
{{- end }}
{{- end }}