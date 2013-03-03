//
//  Constants.h
//  Tanks
//
//  Created by Sveinn Fannar Kristjánsson on 2/17/13.
//  Copyright (c) 2013 Marco Bancale. All rights reserved.
//

#define GRAVITY 100.0f
#define FIXED_TIME_STEP (1.0f / 240.0f)
#define MAX_PROJECTED_POINTS 10
#define PROJECTED_POINT_INTERVAL 30
#define PROJECTION_STEPS 300

enum
{
    kDepthSky,
    kDepthLandscape,
    kDepthProjection,
    kDepthTurret,
    kDepthTank,
    kDepthProjectile,
    kDepthExplosion,
    kDepthDebugNode,
    kDepthHud,
    kDepthControls
};


