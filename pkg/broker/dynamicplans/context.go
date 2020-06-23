package dynamicplans

import (
	"github.com/mongodb/go-client-mongodb-atlas/mongodbatlas"
	"github.com/mongodb/mongodb-atlas-service-broker/pkg/broker/credentials"
)

type Context struct {
	Project     *mongodbatlas.Project `json:"project,omitempty"`
	Cluster     *mongodbatlas.Cluster `json:"cluster,omitempty"`
	Credentials *credentials.Credentials
}

func DefaultCtx(creds *credentials.Credentials) Context {
	return Context{
		Project:     &mongodbatlas.Project{},
		Cluster:     &mongodbatlas.Cluster{},
		Credentials: creds,
	}
}
