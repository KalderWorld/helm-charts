{{/*
Expand the name of the chart.
*/}}
{{- define "kalder-backend.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kalder-backend.fullname" -}}
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
{{- define "kalder-backend.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "kalder-backend.labels" -}}
helm.sh/chart: {{ include "kalder-backend.chart" . }}
{{ include "kalder-backend.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "kalder-backend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kalder-backend.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "kalder-backend.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "kalder-backend.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "kalder-backend.envFrom" -}}
- secretRef:
    name: {{ include "kalder-backend.fullname" . }}-db
- secretRef:
    name: {{ include "kalder-backend.fullname" . }}-client
- secretRef:
    name: {{ include "kalder-backend.fullname" . }}-fidel
- secretRef:
    name: {{ include "kalder-backend.fullname" . }}-auth0-actions
- secretRef:
    name: {{ include "kalder-backend.fullname" . }}-plaid
- configMapRef:
    name: {{ include "kalder-backend.fullname" . }}-configmap
{{- end }}